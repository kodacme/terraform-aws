#!/bin/sh

export $(cat ./env/.envfile | grep -v ^#)
