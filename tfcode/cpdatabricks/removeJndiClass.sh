#!/bin/sh
for f in $(find /databricks -name '*log4j-core*.jar' 2>/dev/null); do echo "Checking $f..."; zip -q -d $f org/apache/logging/log4j/core/lookup/JndiLookup.class; done