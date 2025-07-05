#!/bin/sh
kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{range .spec.containers[*]}{.image}{"\n"}{end}{end}' 2>/dev/null | sort | uniq | \
while read image;do
  res=$(grype -q "$image" --only-fixed)
  if ! echo $res | grep -q 'No vulnerabilities'; then
    echo ">>> $image";
    echo "$res"
  fi
done
