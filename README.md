Requirements
- Quartus Prime 23.1std Lite
- Intel EDS Standard 17.0
- SD Card 2gb
- DE10-nano


Brief Introduction:
- HITS Real-Time FPGA TileCal Simulator to test online reconstruction techniques

How to run:
- Create a bootable SD card (2GB Minimum) with the image shared
- Put the SD card on de DE10-nano board
- MSEL switches must be all in "ON" position
- Connect an Ethernet Cable
- Turn on the board
- The Linux will boot and automaticaly programs the FPGA
- Discover the IP of the board (IP Scanner or COM comunication)
- Connect with SSH to communicate with the board
- Login: root  | Password: simhits
- SSH Command: " ./change_occupancy"
- To change the occupancy or offset, follow the program menu
- Open the project in Quartus
- Connect the board in the USB BLASTER II port
- Go in "Files" and open the "stp1.stp"
- Check if the JTAG Chain Configuration is configurated correctly
- Press in "Autorun Analysis": Now, it is possible to see the occupancy changing with the SSH command
- More details and explanations will be added 
