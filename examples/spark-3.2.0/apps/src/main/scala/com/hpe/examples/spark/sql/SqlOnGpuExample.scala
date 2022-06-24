package com.hpe.examples.spark.sql

import org.apache.spark.sql.SparkSession

object SqlOnGpuExample {

  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .getOrCreate()

    simpleSelect(spark)
    crossJoin(spark)
    leftJoin(spark)
    whereSelect(spark)
    unionSelect(spark)
    filesInteraction(spark)
    spark.stop()
  }

  def simpleSelect(spark: SparkSession): Unit = {
    println("SIMPLE SELECT")
    import spark.implicits._
    val viewName = "df"
    val df = Seq(1, 2, 3).toDF("value")
    df.createOrReplaceTempView(viewName)

    spark.sql(s"SELECT value FROM $viewName WHERE value <>1").explain()
    spark.sql(s"SELECT value FROM $viewName WHERE value <>1").show()
  }

  def crossJoin(spark: SparkSession): Unit = {
    println("CROSS JOIN")
    import spark.implicits._

    val sc = spark.sparkContext
    val recordsAmount = 50


    val df1 = sc.parallelize(1 to recordsAmount, 1)
      .toDF("test")

    val df2 = sc.parallelize(recordsAmount to recordsAmount * 2, 1)
      .toDF("test")

    df1.crossJoin(df2).sample(0.1).explain()
    df1.crossJoin(df2).sample(0.1).show()
  }

  def leftJoin(spark: SparkSession): Unit = {
    println("LEFT JOIN")

    import spark.implicits._
    val firstViewName = "leftJoinFirst"
    val secondViewName = "leftJoinSecond"

    Seq((1, "test1"), (2, "test2"), (3, "test3"))
      .toDF("key", "string")
      .createTempView(firstViewName)

    Seq((1, "test4"), (4, "test5"), (2, "test6"))
      .toDF("key", "string")
      .createTempView(secondViewName)


    val df = spark.sql(s"SELECT * FROM $firstViewName LEFT JOIN " +
      s"leftJoinSecond ON $firstViewName.key=$secondViewName.key")

    df.explain()
    df.show()

  }

  def whereSelect(spark: SparkSession): Unit = {
    println("WHERE SELECT")

    import spark.implicits._


    val whereSelectView = "whereSelectView"
    Seq(
      (1, "first"),
      (2, "second"),
      (3, "third")
    ).toDF("key", "string")
      .createTempView(whereSelectView)

    val df = spark.sql(s"SELECT * FROM $whereSelectView WHERE key >= 2")

    df.explain()
    df.show()
  }

  def unionSelect(spark: SparkSession): Unit = {
    println("UNION SELECT")

    import spark.implicits._

    val firstDF = Seq(
      (1, "first"),
      (2, "second"),
      (3, "third")
    ).toDF("key", "string")

    val secondDF = Seq(
      (100, "John"),
      (200, "Mike"),
      (300, "Bob")
    ).toDF("age", "name")

    val resultDF = firstDF.union(secondDF)

    resultDF.explain()
    resultDF.show()
  }

  def filesInteraction(spark: SparkSession): Unit = {
    println("FILES INTERACTION")
    import spark.implicits._
    val pathPrefix = s"/tmp/filesInteraction${System.currentTimeMillis()}"

    Set("parquet", "orc", "json").foreach(
      format => {
        println(format)
        println("Write")
        val path = s"$pathPrefix$format"
        (1 to 100)
          .toDF("val")
          .write
          .format(format)
          .save(path)

        println("Read")
        val df = spark.read
          .format(format)
          .load(path)
          .filter($"val" >= 95)
        df.explain()
        df.show()
      }
    )

  }

}
