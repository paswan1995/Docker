# Docker Lifecycle Explanation 

![](Images/287.png)


***Docker container lifecycle diagram.***
I’ll explain every state, why it exists, when you use it, what commands move containers between states, and best practices.


---

***1. CREATED state 🟧***

What it is:
A container has been created from an image but hasn’t started running yet.

Why it exists:
This allows you to configure the container (e.g., attach networks, set volumes) before it starts.

How to get here:

docker create --name mycontainer nginx

This allocates container resources, assigns an ID, but does not run the process.


***Common uses:***

Pre-creating containers to start later in a controlled way.

Testing configuration before launch.


From here, you can:

Start it → goes to RUNNING.

Remove it (rm) → goes to DELETED.



---

***2. RUNNING state 🟩***

What it is:
The container’s main process is active and executing.

Why it exists:
This is the “working” state where your app or service is serving traffic.

How to get here:

docker run -d --name mycontainer nginx
# OR
docker start mycontainer

(docker run = create + start in one step)

From here, you can:

Stop → moves to EXITED.

Pause → moves to PAUSED.


Best practices while running:

Use --restart unless-stopped for auto-restart on failures.

Monitor logs (docker logs -f mycontainer).

Keep it stateless if possible — store persistent data in volumes.



---

3. PAUSED state 🟨

What it is:
Container process is frozen (suspended). CPU is paused, but memory remains allocated.

Why it exists:
Lets you temporarily halt processing without stopping the container. Useful for maintenance or debugging.

How to get here:

docker pause mycontainer

From here, you can:

Unpause → goes back to RUNNING.


Notes:

Paused containers still consume memory.

Good for momentarily pausing heavy processes to free CPU.



---

4. EXITED state 🟥

What it is:
The container’s process has stopped, but its data (filesystem, logs, metadata) still exist.

Why it exists:
Keeps the container’s history and data so you can restart it without recreating it.

How to get here:

docker stop mycontainer
# OR container process finishes naturally

From here, you can:

Start → goes back to RUNNING.

Remove (rm) → goes to DELETED.


Tip:
Use docker ps -a to see exited containers.


---

5. DELETED state ⚫

What it is:
Container is removed from the system entirely — no data, no metadata.

Why it exists:
Frees up space and removes clutter.

How to get here:

docker rm mycontainer

Tip:

Use docker rm -f to force remove a running container.

Removing a container does not remove its image — use docker rmi for that.



---

Command summary from the diagram

Action	Command Example	From → To

CREATE	docker create nginx	— → CREATED
START	docker start mycontainer	CREATED/EXITED → RUNNING
RUN	docker run nginx	— → RUNNING
PAUSE	docker pause mycontainer	RUNNING → PAUSED
UNPAUSE	docker unpause mycontainer	PAUSED → RUNNING
STOP	docker stop mycontainer	RUNNING → EXITED
RM	docker rm mycontainer	CREATED/EXITED → DELETED



---

Lifecycle in one real example

# 1. Create only (CREATED)
docker create --name test nginx

# 2. Start (RUNNING)
docker start test

# 3. Pause (PAUSED)
docker pause test

# 4. Unpause (RUNNING)
docker unpause test

# 5. Stop (EXITED)
docker stop test

# 6. Remove (DELETED)
docker rm test


---

Alright — here’s your Docker Container Lifecycle Cheat Sheet in a crisp, interview-friendly one-pager format.


---

🐳 Docker Container Lifecycle — Cheat Sheet

States & Transitions

[CREATED] --start--> [RUNNING] --pause--> [PAUSED]
    | rm                   ^   | unpause   |
    v                      |   v           |
 [DELETED] <--rm-- [EXITED] <--stop-- [RUNNING]


---

1. CREATED 🟧

Meaning: Container defined but not running.
Why: Configure before starting.
Enter:

docker create --name mycontainer nginx

Exit:

docker start mycontainer → RUNNING

docker rm mycontainer → DELETED



---

2. RUNNING 🟩

Meaning: Main process is active.
Why: Service is live.
Enter:

docker run -d --name mycontainer nginx   # create + start
docker start mycontainer                 # from CREATED/EXITED

Exit:

docker stop mycontainer → EXITED

docker pause mycontainer → PAUSED



---

3. PAUSED 🟨

Meaning: Process frozen, memory intact.
Why: Temporarily halt CPU without stopping container.
Enter:

docker pause mycontainer

Exit:

docker unpause mycontainer → RUNNING



---

4. EXITED 🟥

Meaning: Process stopped, container data kept.
Why: Restart without rebuild.
Enter:

docker stop mycontainer from RUNNING

Process finishes naturally
Exit:

docker start mycontainer → RUNNING

docker rm mycontainer → DELETED



---

5. DELETED ⚫

Meaning: Container completely removed.
Why: Free up space.
Enter:

docker rm mycontainer
docker rm -f mycontainer   # force remove running




***Common Lifecycle Commands Table***

Action	Command Example	From → To

CREATE	docker create nginx	— → CREATED
START	docker start mycontainer	CREATED/EXITED → RUNNING
RUN	    docker run nginx	— → RUNNING
PAUSE	docker pause mycontainer	RUNNING → PAUSED
UNPAUSE	docker unpause mycontainer	PAUSED → RUNNING
STOP	docker stop mycontainer	RUNNING → EXITED
RM	    docker rm mycontainer	CREATED/EXITED → DELETED



***✅ Pro Tips for Interviews***

docker run = create + start in one go.

Paused containers still consume memory.

Stopped/Exited containers keep filesystem changes until removed.

Deleting a container does not delete the image (docker rmi for that).

Use docker ps -a to see all states.



---
