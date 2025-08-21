#!/usr/bin/env python3
"""
Telemetry Override Script for ComfyUI-Docker
This script ensures that all telemetry functionality is completely disabled
"""

import os
import sys
import logging

# Create a no-op useTelemetry function that can be imported
def useTelemetry(*args, **kwargs):
    """
    No-op telemetry function that does nothing
    This replaces any actual telemetry functionality with a harmless no-op
    """
    pass

def disable_telemetry():
    """
    Comprehensive telemetry disabling function
    This function sets all known telemetry-related environment variables
    and creates no-op functions for any telemetry functions that might exist.
    """
    
    # Set environment variables to disable telemetry
    telemetry_env_vars = {
        'HF_HUB_DISABLE_TELEMETRY': '1',
        'DO_NOT_TRACK': '1',
        'DISABLE_TELEMETRY': '1',
        'TELEMETRY_DISABLED': '1',
        'NO_ANALYTICS': '1',
        'ANALYTICS_DISABLED': '1',
        'HUGGINGFACE_HUB_DISABLE_TELEMETRY': '1',
        'TRANSFORMERS_OFFLINE': '1',
        'TORCH_TELEMETRY_DISABLED': '1'
    }
    
    for var, value in telemetry_env_vars.items():
        os.environ[var] = value
        print(f"Set {var}={value}")
    
    # Make the no-op function available globally
    globals()['useTelemetry'] = useTelemetry
    
    # Also create common telemetry function names as no-ops
    telemetry_functions = [
        'track_event',
        'send_telemetry',
        'analytics_track',
        'report_usage',
        'log_telemetry',
        'collect_metrics',
        'send_metrics'
    ]
    
    for func_name in telemetry_functions:
        globals()[func_name] = useTelemetry
    
    print("Telemetry has been completely disabled")
    return useTelemetry

def patch_imports():
    """
    Monkey patch common telemetry modules to prevent any telemetry from being sent
    """
    
    # Create a mock telemetry module
    class MockTelemetryModule:
        def __init__(self):
            pass
        
        def __getattr__(self, name):
            return useTelemetry
        
        def __call__(self, *args, **kwargs):
            return useTelemetry
    
    # Replace any telemetry modules that might be imported
    mock_module = MockTelemetryModule()
    
    # List of potential telemetry module names to mock
    telemetry_modules = [
        'telemetry',
        'analytics',
        'usage_tracking',
        'metrics',
        'huggingface_hub.utils.telemetry',
        'transformers.utils.telemetry'
    ]
    
    for module_name in telemetry_modules:
        sys.modules[module_name] = mock_module
    
    print("Telemetry imports have been patched")

if __name__ == "__main__":
    # Disable telemetry when this script is run directly
    useTelemetry = disable_telemetry()
    patch_imports()
    print("Telemetry override script completed successfully")