import sys
from pyspark.sql import SparkSession

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test Pandas App") \
        .getOrCreate()

    df1 = spark.createDataFrame([(1, 1)], ("column", "value"))
    df2 = spark.createDataFrame([(1, 1)], ("column", "value"))

    res = df1.groupby("COLUMN").cogroup(
        df2.groupby("COLUMN")
    ).applyInPandas(lambda r, l: r + l, df1.schema)

    res.explain()
    res.show()

    spark.stop()
