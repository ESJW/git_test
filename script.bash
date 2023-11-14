file_path="./userfile.txt"
front=frontend.yaml
back=backend.yaml
db=db.yaml

# userfile에서 값 가져오기
line_number=0
while IFS= read -r line; do
line_number=$((line_number + 1))
case $line_number in
	1) front_image="$line" ;;
	2) back_image="$line" ;;
	3) db_image="$line" ;;
	4) front_port="$line" ;;
	5) back_port="$line" ;;
esac
done < "$file_path"

# 빈 yaml 파일 생성
touch $front
touch $back
touch $db

if [ -n $front_image]; then
	echo "apiVersion: apps/v1" > $front
	echo "kind: Deployment" >> $front
	echo "metadata:" >> $front
	echo "  name: frontend-deployment" >> $front
	echo "spec:" >> $front
	echo "  selector:" >> $front
	echo "    matchLabels:" >> $front
	echo "      app: front" >> $front
	echo "  replicas: 2" >> $front
	echo "  template:" >> $front
	echo "    metadata:" >> $front
	echo "      labels:" >> $front
	echo "        app: front" >> $front
	echo "    spec:" >> $front
	echo "      affinity:" >> $front
	echo "        podAntiAffinity:" >> $front
	echo "          requiredDuringSchedulingIgnoredDuringExecution:" >> $front
	echo "            - labelSelector:" >> $front
	echo "                matchExpressions:" >> $front
	echo "                  - key: app" >> $front
	echo "                    operator: In" >> $front
	echo "                    values:" >> $front
	echo "                      - front" >> $front
	echo "              topologyKey: \"kubernetes.io/hostname\"" >> $front
	echo "      containers:" >> $front
	echo "        - name: frontend" >> $front
	echo "          image: ${front_image}" >> $front
	echo "          ports:" >> $front
	echo "            - containerPort: ${front_port}" >> $front
	echo "      imagePullSecrets:" >> $front
	echo "        - name: ocirsecret" >> $front
	echo "---" >> $front
	echo "apiVersion: v1" >> $front
	echo "kind: Service" >> $front
	echo "metadata:" >> $front
	echo "  name: front-service" >> $front
	echo "spec:" >> $front
	echo "  type: LoadBalancer" >> $front
	echo "  ports:" >> $front
	echo "    - port: ${front_port}" >> $front
	echo "      protocol: TCP" >> $front
	echo "      targetPort: ${front_port}" >> $front
	echo "  selector:" >> $front
	echo "    app: front" >> $front
fi

if [ -n $back_image]; then
	echo "apiVersion: apps/v1" > $back
	echo "kind: Deployment" >> $back
	echo "metadata:" >> $back
	echo "  name: backend-deployment" >> $back
	echo "spec:" >> $back
	echo "  selector:" >> $back
	echo "    matchLabels:" >> $back
	echo "      app: back" >> $back
	echo "  replicas: 2" >> $back
	echo "  template:" >> $back
	echo "    metadata:" >> $back
	echo "      labels:" >> $back
	echo "        app: back" >> $back
	echo "    spec:" >> $back
	echo "      affinity:" >> $back
	echo "        podAntiAffinity:" >> $back
	echo "          requiredDuringSchedulingIgnoredDuringExecution:" >> $back
	echo "            - labelSelector:" >> $back
	echo "                matchExpressions:" >> $back
	echo "                  - key: app" >> $back
	echo "                    operator: In" >> $back
	echo "                    values:" >> $back
	echo "                      - back" >> $back
	echo "              topologyKey: \"kubernetes.io/hostname\"" >> $back
	echo "      containers:" >> $back
	echo "        - name: backend" >> $back
	echo "          image: ${back_image}" >> $back
	echo "          ports:" >> $back
	echo "            - containerPort: ${back_port}" >> $back
	echo "      imagePullSecrets:" >> $back
	echo "        - name: ocirsecret" >> $back
	echo "---" >> $back
	echo "apiVersion: v1" >> $back
	echo "kind: Service" >> $back
	echo "metadata:" >> $back
	echo "  name: api" >> $back
	echo "spec:" >> $back
	echo "  type: ClusterIP" >> $back
	echo "  ports:" >> $back
	echo "    - port: ${back_port}" >> $back
	echo "      protocol: TCP" >> $back
	echo "      targetPort: ${back_port}" >> $back
	echo "  selector:" >> $back
	echo "    app: back" >> $back
fi

if [-n $db_image ]; then
	echo "apiVersion: v1" > $db
	echo "kind: PersistentVolume" >> $db
	echo "metadata:" >> $db
	echo "  name: db-pv" >> $db
	echo "  labels:" >> $db
	echo "    volume: db-pv" >> $db
	echo "spec:" >> $db
	echo "  capacity:" >> $db
	echo "    storage: 1Gi" >> $db
	echo "  volumeMode: Filesystem" >> $db
	echo "  accessModes:" >> $db
	echo "    - ReadWriteMany" >> $db
	echo "  persistentVolumeReclaimPolicy: Retain " >> $db
	echo "  storageClassName: \"\" " >> $db
	echo "  nfs:" >> $db
	echo "    path: /nfs-share/db" >> $db
	echo "    server: nfs-server-ip" >> $db
	echo "---" >> $db
	echo "apiVersion: v1" >> $db
	echo "kind: PersistentVolumeClaim" >> $db
	echo "metadata:" >> $db
	echo "  name: db-pvc" >> $db
	echo "spec:" >> $db
	echo "  selector:" >> $db
	echo "    matchLabels:" >> $db
	echo "      volume: db-pv" >> $db
	echo "  accessModes:" >> $db
	echo "  - ReadWriteMany" >> $db
	echo "  resources:" >> $db
	echo "    requests:" >> $db
	echo "      storage: 1Gi" >> $db
	echo "  storageClassName: \"\" " >> $db
	echo "---" >> $db
	echo "apiVersion: apps/v1" >> $db
	echo "kind: Deployment" >> $db
	echo "metadata:" >> $db
	echo "  name: db-deployment" >> $db
	echo "  labels:" >> $db
	echo "    app: db-deployment" >> $db
	echo "spec:" >> $db
	echo "  replicas: 1" >> $db
	echo "  selector:" >> $db
	echo "    matchLabels:" >> $db
	echo "      app: db" >> $db
	echo "  template:" >> $db
	echo "    metadata:" >> $db
	echo "      name: db" >> $db
	echo "      labels:" >> $db
	echo "        app: db" >> $db
	echo "    spec:" >> $db
	echo "      containers:" >> $db
	echo "        - name: db-container" >> $db
	echo "          image: ${db_image}" >> $db
	echo "          env: " >> $db
	echo "            - name: MONGO_INITDB_DATABASE" >> $db
	echo "              value: database" >> $db
	echo "          ports:" >> $db
	echo "            - containerPort: ${db_port}" >> $db
	echo "          volumeMounts:" >> $db
	echo "            - name: db-pv" >> $db
	echo "              mountPath: /data/db" >> $db
	echo "              readOnly: false" >> $db
	echo "      volumes:" >> $db
	echo "        - name: db-pv" >> $db
	echo "          persistentVolumeClaim:" >> $db
	echo "            claimName: db-pvc" >> $db
	echo "---" >> $db
	echo "apiVersion: v1" >> $db
	echo "kind: Service" >> $db
	echo "metadata:" >> $db
	echo "  name: db-service" >> $db
	echo "  labels:" >> $db
	echo "    app: db-service" >> $db
	echo "spec:" >> $db
	echo "  type: ClusterIP" >> $db
	echo "  ports:" >> $db
	echo "    - protocol: TCP" >> $db
	echo "      port: ${db_port}" >> $db
	echo "      targetPort: ${db_port}" >> $db
	echo "  selector:" >> $db
	echo "    app: db" >> $db
fi