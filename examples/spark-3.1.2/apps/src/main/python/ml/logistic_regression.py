from pyspark.ml.classification import LogisticRegression
from pyspark.sql import SparkSession
import sys


if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test Logistic Regression ML App") \
        .getOrCreate()

    training = spark.read.format("libsvm").load(
        sys.argv[1]
    )

    lr = LogisticRegression(maxIter=10, regParam=0.3, elasticNetParam=0.8)
    lrModel = lr.fit(training)
    trainingSummary = lrModel.summary
    fMeasure = trainingSummary.fMeasureByThreshold
    maxFMeasure = fMeasure.groupBy().max('F-Measure').select('max(F-Measure)').head()

    bestThreshold = fMeasure.where(
        fMeasure['F-Measure'] == maxFMeasure['max(F-Measure)']
    ).select('threshold')

    bestThreshold.explain()
    bestThreshold.show()

    spark.stop()
