#!/usr/bin/env python3

print("=======================================")
print("      EMON INDUSTRY (EFIRM ERP)        ")
print("      BDT VAT INVOICE GENERATOR        ")
print("=======================================")

item_price = 1500.0  # Base price in BDT
qty = 2
subtotal = item_price * qty
vat_rate = 0.15 # 15% VAT
vat_amount = subtotal * vat_rate
total = subtotal + vat_amount

print(f"Item Price:       {item_price} BDT")
print(f"Quantity:         {qty}")
print(f"Subtotal:         {subtotal} BDT")
print(f"VAT (15%):        {vat_amount} BDT")
print("---------------------------------------")
print(f"TOTAL PAYABLE:    {total} BDT")
print("=======================================")
print("NBR BIN: 00123456789 | RJSC: C-123456")
