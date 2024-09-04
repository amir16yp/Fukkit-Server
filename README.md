# Fukkit Server

![Fukkit Server Logo](https://github.com/user-attachments/assets/5d3d4d32-d588-4d05-b901-c28d328999f9)

Fukkit Server is an enhanced decompilation and recompilation of the Minecraft Classic 0.30 server, offering quality-of-life improvements and modern features for a better gameplay experience.

## 🌟 Features

- **Unlimited Players**: Remove the 32-player cap for larger communities.
- **Bukkit-like API**: Modernized API for seamless plugin development, including:
  - **Event Handling**: Register and manage events (e.g., player joins, chat messages, player movements).
  - **Command System**: Implement custom commands with permission support and world management.
- **Support for .cw and .dat level files**
- **Supports announcing to Classicube's server list and Classicube auth**
- **Performance Optimizations**: Improved server efficiency for smoother gameplay.
- **Extended Customization**: More options to tailor your server to your needs.
- **CPE Support**: Partial CPE support. See [tracking](https://github.com/amir16yp/Fukkit-Server/issues/2)
## 🚀 Quick Start

1. Download the latest `.jar` file from the [Releases](https://github.com/amir16yp/Fukkit-Server/releases) page.
2. Ensure you have Java 8 JRE installed on your system.
3. Run the server using the following command:
   ```
   java -jar server.jar
   ```

## 🛠️ Building from Source

### Prerequisites

- Java 8 JDK
- `dos2unix` package
- Git Bash (for Windows users)

### Steps

1. **Clone the repository**
   ```sh
   git clone https://github.com/amir16yp/Fukkit-Server.git
   cd Fukkit-Server
   ```

2. **Download original .jars**
   ```sh
   bash download.sh
   ```

3. **Decompile jars**
   ```sh
   bash decompile.sh
   ```

4. **Apply patches**
   ```sh
   bash apply_patches.sh
   ```

5. **Optional: Add your own patches**
   - Modify files in `work/server/`
   - Run `bash gen_patches.sh`

6. **Compile**
   - Linux:
     ```sh
     bash compile-server.sh
     ```
   - Windows:
     ```sh
     .\compile_server.ps1
     ```

## 📚 Documentation

Coming soon!

## 📄 License

Fukkit Server is licensed under the [Unlicense](LICENSE).

## 📞 Support

If you encounter any issues or have questions, please [open an issue](https://github.com/amir16yp/Fukkit-Server/issues) on our GitHub repository.



