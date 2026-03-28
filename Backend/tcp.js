// testTcp.js
import net from "net";

const server = net.createServer((socket) => {
  socket.write("Hello from TCP server!\n");
  socket.end();
});

const PORT = 5005;
server.listen(PORT, "127.0.0.1", () => {
  console.log(`TCP server listening on 127.0.0.1:${PORT}`);
});

server.on("error", (err) => {
  console.error("Server error:", err);
});
