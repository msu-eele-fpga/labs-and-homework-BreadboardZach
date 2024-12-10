# Lab 11: Platform Device Driver

## What is the purpose of the platform bus?

The purpose of the platform bus is to enable a "easy" way for an operating system to discover and inform
itself on the hardware devices that exist. This bus allows the OS to pull any necessary device information
for proper operation.

## Why is the device driver's compatible property important?

The compatibility property is important because if the compatability string matches the string of the device
tree node, it will get bound to it. 

## What is the probe function's purpose?

Once the device is bound to the driver, the probe function initallizes and sets up the driver.

## How does the driver know what memory addresses are associated with your device?

The driver knows what memory address are coorelated with out device because we define it. We first designed
the offset within the kernel to understand the hex value associated with the de10nano. After all of that was
instantiated we defined the specific hps_control, led_reg, and base_rate address values.

## What are the two ways we can write to our device's registers?

We can interface the registers through either the misc subsystem or the exported sysfs attributes.

## What is the purpose of our struct led_patterns_dev state container?

The struct holds state information including memory addresses, pointers to registers, and other device information. It provides a struct(ured) way to manage and access hardware memory and state.