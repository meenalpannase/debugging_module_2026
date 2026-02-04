/*
╔════════════════════════════════════════════════════════════════════════════╗
║                    SPI PROTOCOL OVERVIEW                                   ║
╚════════════════════════════════════════════════════════════════════════════╝

SIGNALS:
────────
• SCLK  - Serial Clock (Master generates)
• MOSI  - Master Out Slave In (Data from Master to Slave)
• MISO  - Master In Slave Out (Data from Slave to Master)
• CS_N  - Chip Select (Active Low)

MODES:
──────
• CPOL (Clock Polarity): 0 or 1
• CPHA (Clock Phase): 0 or 1
• 4 modes total: (CPOL=0,CPHA=0), (0,1), (1,0), (1,1)

TRANSFER:
─────────
• Master initiates by asserting CS_N (low)
• Data shifted MSB first (typically)
• Transfer size: 8, 16, or 32 bits
• Full duplex (simultaneous TX/RX)

*/
