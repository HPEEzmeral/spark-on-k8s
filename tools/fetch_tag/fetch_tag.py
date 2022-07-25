import argparse
import os
import re
import sys

import requests
import yaml

class FetchTag(object):
    USER = "_token"

    def __init__(self):
        cur_dir = os.path.dirname(__file__)

        # will be a dict of <string, list>
        self.chart_files = dict()
        self.example_files = dict()

        self.re_pattern = re.compile("([a-zA-Z_-]+-\\d+.\\d+.*):(.+)")

        self.charts_dir = os.path.abspath(os.path.join(cur_dir, "../../charts"))
        self.examples_dir = os.path.abspath(os.path.join(cur_dir, "../../examples"))
        self.imgtxt_file = os.path.abspath(os.path.join(cur_dir, "../imagelist.txt"))
    def run(self):
        self.get_tags_from_charts_yaml(self.charts_dir, self.chart_files, ["livy-0.8.0", "metastore-3.1.1", "mysql-operator", "spark-3.1.1", "spark-hs-3.1.1"])
        self.get_tags_from_examples_yaml(self.examples_dir, self.example_files, ["spark-2.4.4", "spark-3.1.1"])
        print(self.chart_files)
        print(self.example_files)
        with open(self.imgtxt_file, "w") as file:
            for key in self.chart_files:
                for k, v in self.chart_files[key].items():
                    file.write(k + ":" + v)
                    file.write("\n")
            for key in self.example_files:
                for k, v in self.example_files[key].items():
                    file.write(k + ":" + v)
                    file.write("\n")

    def get_tags_from_charts_yaml(self, start_dir, process_dict, ignore_dirs=None):
        if ignore_dirs is None:
            ignore_dirs = []
        for dirpath, dirnames, filenames in os.walk(start_dir):
            process = True
            for a_file in filenames:
                if not a_file.lower().endswith("values.yaml"):
                    continue
                for ignore_dir in ignore_dirs:
                    if ignore_dir in dirpath:
                        process = False

                if not process:
                    continue

                full_file = os.path.join(dirpath, a_file)
                with open(full_file, "r") as file:
                    try:
                        contents = yaml.safe_load(file)
                        append_dict = dict()
                        key = contents['image']['imageName']
                        value = contents['image']['tag']
                        if value not in append_dict.values():
                            append_dict[key] = value
                        append_dict[key] = value
                        if len(append_dict) > 0:
                                process_dict[full_file] = append_dict
                    except yaml.YAMLError as exc:
                        print(exc)

    def get_tags_from_examples_yaml(self, start_dir, process_dict, ignore_dirs=None):
        if ignore_dirs is None:
            ignore_dirs = []
        for dirpath, dirnames, filenames in os.walk(start_dir):
            process = True
            for a_file in filenames:
                if not a_file.lower().endswith(".yaml"):
                    continue
                for ignore_dir in ignore_dirs:
                    if ignore_dir in dirpath:
                        process = False

                if not process:
                    continue

                full_file = os.path.join(dirpath, a_file)
                with open(full_file, "r") as file:
                    contents = file.read()
                    found = self.re_pattern.findall(contents)

                    a_len = len(found)
                    if a_len > 0:
                        append_dict = dict()
                        for found_dict in found:
                            key = found_dict[0]
                            value = found_dict[1].replace('"', '')
                            if key.find(">") >= 0:
                                continue
                            if "/" in key:
                                key = key[key.rindex("/") + 1:]
                            if key.find("mapr-252711") >= 0:
                                continue
                            append_dict[key] = value
                        if len(append_dict) > 0:
                            if append_dict not in process_dict.values():
                                process_dict[full_file] = append_dict

if __name__ == '__main__':
    fetch_tag = FetchTag()
    fetch_tag.run()
