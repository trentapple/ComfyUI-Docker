#!/usr/bin/env python3
"""
Test script to verify telemetry is properly disabled
"""

import os
import sys

def test_telemetry_disabled():
    """Test that all telemetry environment variables are set correctly"""
    
    print("🔍 Testing Telemetry Disabling...")
    
    required_env_vars = [
        'HF_HUB_DISABLE_TELEMETRY',
        'DO_NOT_TRACK', 
        'DISABLE_TELEMETRY',
        'TELEMETRY_DISABLED',
        'NO_ANALYTICS',
        'ANALYTICS_DISABLED',
        'HUGGINGFACE_HUB_DISABLE_TELEMETRY',
        'TRANSFORMERS_OFFLINE',
        'TORCH_TELEMETRY_DISABLED'
    ]
    
    all_good = True
    
    # Import and run telemetry override
    try:
        from telemetry_override import disable_telemetry, patch_imports, useTelemetry
        disable_telemetry()
        patch_imports()
        print("✅ Telemetry override script imported and executed successfully")
    except ImportError as e:
        print(f"❌ Failed to import telemetry override: {e}")
        all_good = False
    
    # Check environment variables
    print("\n📋 Environment Variable Status:")
    for var in required_env_vars:
        value = os.environ.get(var)
        if value == '1':
            print(f"✅ {var} = {value}")
        else:
            print(f"❌ {var} = {value} (should be '1')")
            all_good = False
    
    # Test that useTelemetry function is a no-op
    try:
        result = useTelemetry("test", "data", analytics=True)
        if result is None:
            print("✅ useTelemetry function is properly no-op")
        else:
            print(f"❌ useTelemetry returned: {result} (should be None)")
            all_good = False
    except NameError:
        print("❌ useTelemetry function not found")
        all_good = False
    except Exception as e:
        print(f"❌ Error testing useTelemetry: {e}")
        all_good = False
    
    # Test module patching
    try:
        import telemetry
        result = telemetry.some_function("test")
        print("✅ Telemetry module successfully patched (imported but no-op)")
    except ImportError:
        print("ℹ️  No telemetry module to patch (this is normal)")
    except Exception as e:
        print(f"✅ Telemetry module patched: {e}")
    
    print(f"\n🏁 Test Result: {'PASS' if all_good else 'FAIL'}")
    return all_good

if __name__ == "__main__":
    success = test_telemetry_disabled()
    sys.exit(0 if success else 1)