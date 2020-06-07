# Ansible Modules

This directory contains Ansible modules.

## About

Ansible modules are single-file executables that take a single command-line
argument: the name of a temp file that contains module parameters.

Your module has to parse these parameters, perform a computation, then return
results as a JSON object.

Note that modules can be written in any language: BASH, Ruby or Python.  

Note also that modules have to be a single-file executable.  They are copied to
the target machine, and therefore cannot rely on multi-file execution strategies.

## Usage

See the file `_example_playbook.yml` to see examples on how to call the modules
from a playbook

