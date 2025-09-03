#!/usr/bin/env python3
"""
Convert parade_2025.csv to JSON format for easier programmatic access
"""

import csv
import json
from pathlib import Path

def convert_csv_to_json():
    """Convert CSV to JSON format"""
    csv_file = Path("_data/parade_2025.csv")
    json_file = Path("_data/parade_2025.json")
    
    if not csv_file.exists():
        print(f"Error: {csv_file} not found!")
        return
    
    contingents = []
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            # Clean up the data and convert to proper types
            contingent = {}
            
            # Basic info
            if row['order'].strip():
                contingent['order'] = int(row['order'])
            if row['zone'].strip():
                contingent['zone'] = row['zone'].strip()
            if row['time'].strip():
                contingent['time'] = row['time'].strip()
            if row['name'].strip():
                contingent['name'] = row['name'].strip()
            if row['Company Name'].strip():
                contingent['company_name'] = row['Company Name'].strip()
            if row['First Name'].strip():
                contingent['first_name'] = row['First Name'].strip()
            if row['Last Name'].strip():
                contingent['last_name'] = row['Last Name'].strip()
            if row['category'].strip():
                contingent['category'] = row['category'].strip()
            
            # Numbers
            marchers = row['marchers'].strip()
            if marchers:
                if marchers.isdigit():
                    contingent['marchers'] = int(marchers)
                else:
                    contingent['marchers'] = marchers  # Keep as string if it's like ">20" or "<20"
            
            if row['sound'].strip():
                contingent['sound'] = row['sound'].strip()
            if row['permalink'].strip():
                contingent['permalink'] = row['permalink'].strip()
            
            # Vehicles
            basic_vehicle = row['basic_vehicle'].strip()
            if basic_vehicle:
                if basic_vehicle.isdigit():
                    contingent['basic_vehicle'] = int(basic_vehicle)
                else:
                    contingent['basic_vehicle'] = basic_vehicle
            
            large_vehicle = row['large_vehicle'].strip()
            if large_vehicle:
                if large_vehicle.isdigit():
                    contingent['large_vehicle'] = int(large_vehicle)
                else:
                    contingent['large_vehicle'] = large_vehicle
            
            if row['notes'].strip():
                contingent['notes'] = row['notes'].strip()
            if row['description'].strip():
                contingent['description'] = row['description'].strip()
            if row['honor'].strip():
                contingent['honor'] = row['honor'].strip()
            
            # Contact info
            if row['contact_1'].strip():
                contingent['contact_1'] = row['contact_1'].strip()
            if row['email'].strip():
                contingent['email'] = row['email'].strip()
            if row['phone_1'].strip():
                contingent['phone_1'] = row['phone_1'].strip()
            if row['contact_2'].strip():
                contingent['contact_2'] = row['contact_2'].strip()
            if row['phone_2'].strip():
                contingent['phone_2'] = row['phone_2'].strip()
            
            # Social media
            if row['website'].strip():
                contingent['website'] = row['website'].strip()
            if row['facebook'].strip():
                contingent['facebook'] = row['facebook'].strip()
            if row['instagram'].strip():
                contingent['instagram'] = row['instagram'].strip()
            if row['twitter'].strip():
                contingent['twitter'] = row['twitter'].strip()
            
            contingents.append(contingent)
    
    # Write to JSON file
    with open(json_file, 'w', encoding='utf-8') as f:
        json.dump(contingents, f, indent=2, ensure_ascii=False)
    
    print(f"Successfully converted {len(contingents)} contingents to {json_file}")
    print(f"JSON file is ready at: {json_file}")

if __name__ == "__main__":
    convert_csv_to_json()
