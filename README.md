[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/d5nOy1eX)

for q3 a i use dthe following commands:
strings target_shezazbp-coder
file target_shezazbp-coder
riscv64-linux-gnu-objdump -d target_shezazbp-coder \ --start-address=0x10600 \ --stop-address=0x10700
riscv64-linux-gnu-objdump -d target_shezazbp-coder | grep strcmp
riscv64-linux-gnu-objdump -s target_shezazbp-coder | grep -A 5 83f80
riscv64-linux-gnu-objdump -s target_shezazbp-coder | grep -A 10 5e090
