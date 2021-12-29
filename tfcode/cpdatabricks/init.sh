#!/bin/sh
# Quoting the label (i.e. EOF) with single quotes to disable variable interpolation.
cat << 'EOF' > /databricks/driver/conf/00-custom-spark.conf
[driver] {
  "spark.driver.extraJavaOptions" = "-Dlog4j2.formatMsgNoLookups=true"
  "spark.executor.extraJavaOptions" = "-Dlog4j2.formatMsgNoLookups=true"
}
EOF
