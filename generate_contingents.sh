#!/bin/bash

# Script to generate contingent markdown files from parade_2025.csv
# Usage: ./generate_contingents.sh

CSV_FILE="_data/parade_2025.csv"
OUTPUT_DIR="_contingents"

# Check if CSV file exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: $CSV_FILE not found!"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Use Python to parse CSV properly and generate files
python3 << 'EOF'
import csv
import re
import os

def clean_filename(name):
    """Clean filename for use in file system"""
    if not name:
        return ""
    # Convert to lowercase, remove special chars, replace spaces with hyphens
    cleaned = re.sub(r'[^a-z0-9 ]', '', name.lower())
    cleaned = re.sub(r'\s+', '-', cleaned)
    cleaned = re.sub(r'-+', '-', cleaned)
    return cleaned.strip('-')

def escape_yaml(text):
    """Escape special characters for YAML"""
    if not text:
        return ""
    return text.replace('"', '\\"')

def format_description(desc):
    """Format description for YAML"""
    if not desc:
        return '""'
    
    # If description contains newlines or is very long, use block scalar
    if '\n' in desc or len(desc) > 80:
        lines = desc.replace('\r\n', '\n').replace('\r', '\n').split('\n')
        formatted_lines = ['  ' + line for line in lines if line.strip()]
        return '>-\n' + '\n'.join(formatted_lines)
    else:
        return f'"{escape_yaml(desc)}"'

# Read and process CSV
with open('_data/parade_2025.csv', 'r', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    
    for row in reader:
        order = row.get('order', '').strip()
        if not order:
            continue
            
        # Clean and format order number
        try:
            order_num = int(order)
            order_clean = f"{order_num:03d}"
        except ValueError:
            continue
            
        # Get basic info
        zone = row.get('zone', '').strip()
        time = row.get('time', '').strip()
        name = row.get('name', '').strip()
        company_name = row.get('Company Name', '').strip()
        first_name = row.get('First Name', '').strip()
        last_name = row.get('Last Name', '').strip()
        category = row.get('category', '').strip()
        marchers = row.get('marchers', '').strip()
        sound = row.get('sound', '').strip()
        permalink = row.get('permalink', '').strip()
        basic_vehicle = row.get('basic_vehicle', '').strip()
        large_vehicle = row.get('large_vehicle', '').strip()
        description = row.get('description', '').strip()
        honor = row.get('honor', '').strip()
        contact_1 = row.get('contact_1', '').strip()
        email = row.get('email', '').strip()
        phone_1 = row.get('phone_1', '').strip()
        contact_2 = row.get('contact_2', '').strip()
        phone_2 = row.get('phone_2', '').strip()
        website = row.get('website', '').strip()
        facebook = row.get('facebook', '').strip()
        instagram = row.get('instagram', '').strip()
        twitter = row.get('twitter', '').strip()
        
        # Generate filename
        if name:
            filename_base = clean_filename(name)
            filename = f"{order_clean}_{filename_base}.markdown"
        else:
            filename = f"{order_clean}_contingent.markdown"
            
        # Use company name if name is empty
        display_name = name or company_name
        
        # Combine contact info
        contact = ""
        if first_name and last_name:
            contact = f"{first_name} {last_name}"
        elif contact_1:
            contact = contact_1
            
        # Create output file
        output_path = f"_contingents/{filename}"
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(f"""---
layout: contingent
order: '{order_clean}'
zone: {zone}
time: '{time}'
name: {display_name}
title: {display_name}
category: {category}
marchers: '{marchers}'
sound: '{sound}'
permalink: {permalink}
basic_vehicle: '{basic_vehicle}'
large_vehicle: '{large_vehicle}'
description: {format_description(description)}
honor: '{honor}'
email: {email}
contact: {contact}
phone: {phone_1}
website: '{website}'
facebook: '{facebook}'
instagram: '{instagram}'
twitter: '{twitter}'
---

""")
        
        print(f"Generated: {output_path}")

print("Contingent files generation complete!")
EOF
