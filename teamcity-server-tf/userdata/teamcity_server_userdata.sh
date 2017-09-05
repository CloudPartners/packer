#!/bin/bash

PUBLIC_DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

sed -i "s/{{TEAMCITY_SERVER_DNS}}/$PUBLIC_DNS/g" /etc/nginx/nginx.conf
service nginx restart
chown -R teamcity:teamcity /data
chown -R teamcity:teamcity /artifacts
chkconfig teamcity on
service teamcity start

# echo "Install Kinesis Agent"

# yum install -y aws-kinesis-agent

# cat >/etc/aws-kinesis/agent.json <<EOL
# {
#     "cloudwatch.emitMetrics": true,
#     "firehose.endpoint": "firehose.${region}.amazonaws.com",
#     "cloudwatch.endpoint": "monitoring.${region}.amazonaws.com",
#     "flows":[
#         {
#             "filePattern": "/srv/TeamCity/logs/teamcity-server.*",
#             "deliveryStream": "teamcity-server-stream",
#             "multiLineStartPattern": "^[\\\\[\\\\d\\\\s-:,\\\\]]+",
#             "dataProcessingOptions": [
#                 {
#                     "optionName": "SINGLELINE"
#                 },
#                 {
#                     "optionName": "LOGTOJSON",
#                     "logFormat": "SYSLOG",
#                     "matchPattern": "^\\\\[([\\\\d-\\\\s:-]+)[,\\\\d\\\\s\\\\]]+([A-Z]+)[ -]+([\\\\s\\\\S]+)",
#                     "customFieldNames": [ "timestamp", "severity", "message" ]
#                 }
#             ]
#         }
#     ]
# }
# EOL

# service aws-kinesis-agent start
# chkconfig aws-kinesis-agent on
