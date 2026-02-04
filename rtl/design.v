// ============================================================================
// SIMPLE SPI SLAVE DUT (for testing)
// ============================================================================

module spi_slave (
  input  logic sclk,
  input  logic mosi,
  input  logic cs_n,
  output logic miso
);

  logic [7:0] rx_data;
  logic [7:0] tx_data;
  int bit_count;
  
  always @(posedge sclk or posedge cs_n) begin
    if (cs_n) begin
      bit_count <= 0;
      rx_data <= 8'h00;
    end else begin
      rx_data <= {rx_data[6:0], mosi};
      bit_count <= bit_count + 1;
      
      if (bit_count == 7) begin
        // Echo received data
        tx_data <= rx_data;
      end
    end
  end
  
  assign miso = tx_data[7 - bit_count];
  
endmodule

