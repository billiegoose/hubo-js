# New safer version that ONLY pulls data, not push.
ADDRESS="${1:-hubo}"
achd -r pull $ADDRESS hubo-state &
achd -r pull $ADDRESS hubo-virtual-to-sim &
