import sys
import numpy as np
import pandas as pd
from pyspark.sql import SparkSession

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test DF + arrow App") \
        .getOrCreate()

    pdf = pd.DataFrame(np.arange(20).reshape(4,5))
    df = spark.createDataFrame(pdf)
    result_pdf = df.select("*")

    result_pdf.explain()
    print(result_pdf.toPandas())

    spark.stop()
