import sys
import pandas as pd
from pyspark.sql.functions import col, pandas_udf
from pyspark.sql.types import LongType
from pyspark.sql import SparkSession

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test DF + pandas + udf App") \
        .getOrCreate()


    def multiply_func(a, b):
        return a * b

    multiply = pandas_udf(multiply_func, returnType=LongType())
    x = pd.Series([1, 2, 3])
    pd_result = multiply_func(x, x).to_json()

    df = spark.createDataFrame(pd.DataFrame(x, columns=["x"]))
    df_result = df.select(multiply(col("x"), col("x")))

    df_result.explain()
    df_result.show()

    spark.stop()
