import sys
from pyspark.sql import SparkSession

from pyspark.mllib.stat import Statistics
from pyspark.mllib.util import MLUtils

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test Data Frame ML App") \
        .getOrCreate()

    input_path = sys.argv[1]
    df = spark.read \
        .format("libsvm") \
        .load(input_path)

    features = MLUtils.convertVectorColumnsFromML(
        df, "features"
    ).select("features")

    features.explain()

    summary = Statistics.colStats(features.rdd.map(lambda r: r.features))

    summary.mean() \
        .tolist()

    spark.stop()

