#!/usr/bin/env python3
"""Module with `schools_by_topic` function"""


def schools_by_topic(mongo_collection, topic):
    """Returns the list of schools having a specific topic"""
    return mongo_collection.find({"topics": topic})
