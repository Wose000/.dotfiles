#!/bin/env bash
ping -c 1 google.com>&/dev/null; echo $?
