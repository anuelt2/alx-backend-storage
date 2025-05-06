#!/usr/bin/env python3
"""Script that provides some stats about Nginx logs stored in MongoDB"""

from pymongo import MongoClient


if __name__ == "__main__":
    client = MongoClient()
    collection = client.logs.nginx

    num_logs = collection.count_documents({})
    print(f"{num_logs} logs")

    methods = ["GET", "POST", "PUT", "PATCH", "DELETE"]

    print("Methods:")
    for method in methods:
        count = collection.count_documents({"method": method})
        print(f"\tmethod {method}: {count}")

    count_get_with_status = collection.count_documents(
            {
                "method": "GET",
                "path": "/status"
                }
            )
    print(f"{count_get_with_status} status check")

    ips = collection.aggregate(
            [
                {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
                {"$sort": {"count": -1}},
                {"$limit": 10},
                ]
            )

    print("IPs:")
    for ip in ips:
        print(f"\t{ip['_id']}: {ip['count']}")
