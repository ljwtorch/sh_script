#!/bin/bash

# 定义一个函数来处理不同的 jmx 实例
manage_jmx_instance() {
  local instance="$1"
  local port=$((9800 + ${instance#kafka})) # 提取实例名称后的数字并加9800作为端口
  local pid_file="/var/run/jmx_${instance}_httpserver.pid"
  local log_file="/root/monitor/log/${instance}.log"

  case "$2" in
    start)
      if [ -f "$pid_file" ]; then
        echo "jmx_${instance}_httpserver is already running."
      else
        # 使用对应的端口号启动 jmx_prometheus_httpserver
        nohup java -jar /root/monitor/jmx_prometheus_httpserver-0.20.0.jar $port /root/monitor/${instance}.yml >> "$log_file" 2>&1 &
        echo $! > "$pid_file"
        echo "jmx_${instance}_httpserver on port $port started."
      fi
      ;;
    status)
      if [ -f "$pid_file" ]; then
        PID=$(cat "$pid_file")
        ps -p $PID > /dev/null 2>&1
        if [ $? -eq 0 ]; then
          echo "jmx_${instance}_httpserver is running (PID $PID)."
        else
          echo "jmx_${instance}_httpserver is not running but PID file exists."
        fi
      else
        echo "jmx_${instance}_httpserver is not running."
      fi
      ;;
    stop)
      if [ -f "$pid_file" ]; then
        PID=$(cat "$pid_file")
        # 使用 kill 而不是 kill -9 以避免过于激进地终止进程
        kill $PID
        rm -f "$pid_file"
        echo "jmx_${instance}_httpserver stopped."
      else
        echo "jmx_${instance}_httpserver is not running."
      fi
      ;;
    *)
      echo "Usage: $0 {start|status|stop}"
      exit 1
      ;;
  esac
}

# 根据提供的选项调用函数来管理不同的 jmx 实例
for instance in kafka1 kafka2 kafka3; do
  manage_jmx_instance "$instance" "$1"
done

exit 0