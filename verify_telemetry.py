#!/usr/bin/env python3
"""
Quick verification script to check telemetry status in Docker container
"""

import os

def verify_telemetry_disabled():
    """Quick check of telemetry environment variables"""
    print("🔒 ComfyUI Telemetry Status Check")
    print("=" * 40)
    
    telemetry_vars = [
        'HF_HUB_DISABLE_TELEMETRY',
        'DO_NOT_TRACK', 
        'DISABLE_TELEMETRY',
        'TELEMETRY_DISABLED'
    ]
    
    all_disabled = True
    for var in telemetry_vars:
        value = os.environ.get(var)
        status = "✅ DISABLED" if value == '1' else "❌ NOT SET"
        print(f"{var}: {status}")
        if value != '1':
            all_disabled = False
    
    print("=" * 40)
    if all_disabled:
        print("🎉 SUCCESS: All telemetry is properly disabled!")
    else:
        print("⚠️  WARNING: Some telemetry may not be disabled!")
    
    return all_disabled

if __name__ == "__main__":
    verify_telemetry_disabled()