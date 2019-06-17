# 4diac FORTE with OPC UA support

Since the only way to have OPC UA support on FORTE is compiling from sources, this docker project will do that for you.

## Motivations

I wanted to test FORTE OPC UA on a Mac, so running it from a docker container sounded like more efficient way to achieve that.

## How to Run

```
docker run \
--rm \
--publish 61499:61499 \
--publish 4840:4840 \
--hostname opcserver \
ralexsander/4diac-forte-opc-ua
```
