import struct

files = [
    "/tmp/SpotClientData.pb",
    "/tmp/SpotCachedDeviceData.pb", 
    "/tmp/SpotPublicKeySet.pb"
]

for fname in files:
    print(f"\n{'='*60}")
    print(f"FILE: {fname}")
    print('='*60)
    with open(fname, "rb") as f:
        data = f.read()
    
    print(f"Total size: {len(data)} bytes")
    print(f"Full hex:\n{data.hex()}")
    
    # Extract all possible 32-byte sequences at every offset
    print("\n--- All 32-byte aligned chunks ---")
    for i in range(0, len(data) - 32, 1):
        chunk = data[i:i+32]
        # Look for high-entropy chunks (likely key material, not text)
        entropy = len(set(chunk))
        if entropy > 24:  # keys have high byte diversity
            print(f"  offset {i:4d}: {chunk.hex()}  (entropy={entropy})")
