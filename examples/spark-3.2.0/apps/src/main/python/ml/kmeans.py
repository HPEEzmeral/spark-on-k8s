import sys
from pyspark.sql import SparkSession
from pyspark.ml.clustering import KMeans
from pyspark.ml.evaluation import ClusteringEvaluator

if __name__ == "__main__":
    spark = SparkSession \
        .builder \
        .appName("Test KMeans ML App") \
        .getOrCreate()

    dataset = spark.read.format("libsvm").load(sys.argv[1])

    # Trains a k-means model.
    kmeans = KMeans().setK(2).setSeed(1)
    model = kmeans.fit(dataset)

    # Make predictions
    predictions = model.transform(dataset)

    predictions.explain()

    # Evaluate clustering by computing Silhouette score
    evaluator = ClusteringEvaluator()

    silhouette = evaluator.evaluate(predictions)
    print("Silhouette with squared euclidean distance = " + str(silhouette))

    # Shows the result.
    centers = model.clusterCenters()

    print(centers)

    spark.stop()
