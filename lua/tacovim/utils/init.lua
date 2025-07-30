-- ~/.config/nvim/lua/tacovim/utils/init.lua
-- TacoVim Utility Functions and Managers

-- =============================================================================
-- PROJECT MANAGER
-- =============================================================================

local project_templates = {
  -- Web Development
  { name = "HTML/CSS/JS Website", type = "web", tech = "vanilla" },
  { name = "React App (Vite)", type = "web", tech = "react-vite" },
  { name = "React App (Next.js)", type = "web", tech = "nextjs" },
  { name = "Vue.js App", type = "web", tech = "vue" },
  { name = "Svelte App", type = "web", tech = "svelte" },
  { name = "Angular App", type = "web", tech = "angular" },
  { name = "Astro App", type = "web", tech = "astro" },

  -- Backend APIs
  { name = "Node.js API", type = "backend", tech = "nodejs" },
  { name = "Express.js API", type = "backend", tech = "express" },
  { name = "Fastify API", type = "backend", tech = "fastify" },
  { name = "Python FastAPI", type = "backend", tech = "fastapi" },
  { name = "Python Flask", type = "backend", tech = "flask" },
  { name = "Python Django", type = "backend", tech = "django" },
  { name = "Go HTTP Server", type = "backend", tech = "go" },
  { name = "Rust Axum API", type = "backend", tech = "rust-axum" },

  -- Systems Programming
  { name = "Rust Binary", type = "systems", tech = "rust-bin" },
  { name = "Rust Library", type = "systems", tech = "rust-lib" },
  { name = "C++ CMake", type = "systems", tech = "cpp" },
  { name = "C Project", type = "systems", tech = "c" },
  { name = "Zig Application", type = "systems", tech = "zig" },

  -- JVM Languages
  { name = "Java Spring Boot", type = "backend", tech = "java-spring" },
  { name = "Java Maven", type = "systems", tech = "java-maven" },
  { name = "Java Gradle", type = "systems", tech = "java-gradle" },
  { name = "Kotlin JVM", type = "systems", tech = "kotlin-jvm" },
  { name = "Scala SBT", type = "systems", tech = "scala" },

  -- .NET Ecosystem
  { name = "C# Console App", type = "systems", tech = "csharp-console" },
  { name = "C# Web API", type = "backend", tech = "csharp-webapi" },
  { name = "C# Blazor App", type = "web", tech = "csharp-blazor" },

  -- Mobile Development
  { name = "React Native App", type = "mobile", tech = "react-native" },
  { name = "Flutter App", type = "mobile", tech = "flutter" },
  { name = "Dart Console", type = "systems", tech = "dart" },

  -- Data Science & ML
  { name = "Python Data Science", type = "data", tech = "python-ds" },
  { name = "Jupyter Notebook", type = "data", tech = "jupyter" },
  { name = "R Project", type = "data", tech = "r" },
  { name = "Julia Project", type = "data", tech = "julia" },

  -- Functional Languages
  { name = "Haskell Project", type = "functional", tech = "haskell" },
  { name = "Clojure Project", type = "functional", tech = "clojure" },
  { name = "Elixir Project", type = "functional", tech = "elixir" },

  -- Scripting & Automation
  { name = "Bash Scripts", type = "scripts", tech = "bash" },
  { name = "Lua Script", type = "scripts", tech = "lua" },
  { name = "Ruby Gem", type = "scripts", tech = "ruby" },
}

function TacoVim.ProjectManager.create_project()
  local project_names = {}
  for _, template in ipairs(project_templates) do
    table.insert(project_names, template.name)
  end

  vim.ui.select(project_names, {
    prompt = "🚀 Select project template:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end

    local selected_template
    for _, template in ipairs(project_templates) do
      if template.name == choice then
        selected_template = template
        break
      end
    end

    vim.ui.input({
      prompt = "📝 Project name: ",
    }, function(name)
      if not name or name == "" then return end

      vim.ui.input({
        prompt = "📁 Project directory (default: ~/Projects): ",
        default = vim.fn.expand("~/Projects"),
      }, function(dir)
        if not dir or dir == "" then
          dir = vim.fn.expand("~/Projects")
        end

        local full_path = dir .. "/" .. name
        TacoVim.ProjectManager.create_project_structure(selected_template, full_path, name)
      end)
    end)
  end)
end

function TacoVim.ProjectManager.create_project_structure(template, path, name)
  local result = pcall(vim.fn.mkdir, path, "p")
  if not result then
    vim.notify("❌ Failed to create project directory: " .. path, vim.log.levels.ERROR)
    return
  end

  local tech = template.tech

  -- Create project based on template
  if tech == "cpp" then
    vim.fn.mkdir(path .. "/src", "p")
    vim.fn.mkdir(path .. "/include", "p")
    vim.fn.mkdir(path .. "/build", "p")

    local cmake_content = string.format([[
cmake_minimum_required(VERSION 3.16)
project(%s VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Add compile options
if(MSVC)
    add_compile_options(/W4)
else()
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# Include directories
include_directories(include)

# Add executable
add_executable(%s src/main.cpp)

# Enable testing
enable_testing()

# Set output directory
set_target_properties(%s PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}
)
]], name, name, name)

    local cpp_content = string.format([[
#include <iostream>
#include <string>
#include <vector>
#include <memory>

namespace %s {
    class Application {
    private:
        std::string name_;

    public:
        explicit Application(const std::string& name) : name_(name) {}

        void run() {
            std::cout << "🚀 Starting " << name_ << "..." << std::endl;
            std::cout << "✨ Built with TacoVim C++ template" << std::endl;

            auto numbers = std::vector<int>{1, 2, 3, 4, 5};
            std::cout << "Numbers: ";
            for (const auto& num : numbers) {
                std::cout << num << " ";
            }
            std::cout << std::endl;

            std::cout << "🎉 " << name_ << " completed successfully!" << std::endl;
        }
    };
}

int main() {
    try {
        auto app = std::make_unique<%s::Application>("%s");
        app->run();
        return 0;
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }
}
]], name, name, name)

    vim.fn.writefile(vim.split(cmake_content, "\n"), path .. "/CMakeLists.txt")
    vim.fn.writefile(vim.split(cpp_content, "\n"), path .. "/src/main.cpp")

  elseif tech == "zig" then
    local build_zig = string.format([[
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "%s",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
]], name)

    local main_zig = string.format([[
const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    print("🚀 Hello from {s}!\n", .{"%s"});
    print("✨ Built with TacoVim Zig template\n");

    const numbers = [_]i32{ 1, 2, 3, 4, 5 };
    print("Numbers: ");
    for (numbers) |num| {
        print("{d} ", .{num});
    }
    print("\n");

    print("🎉 {s} completed successfully!\n", .{"%s"});
}

test "basic test" {
    try std.testing.expect(true);
}
]], name, name)

    vim.fn.mkdir(path .. "/src", "p")
    vim.fn.writefile(vim.split(build_zig, "\n"), path .. "/build.zig")
    vim.fn.writefile(vim.split(main_zig, "\n"), path .. "/src/main.zig")

  elseif tech == "rust-bin" then
    vim.fn.system("cd " .. vim.fn.fnamemodify(path, ":h") .. " && cargo new " .. name)

  elseif tech == "go" then
    vim.fn.system("cd " .. path .. " && go mod init " .. name)
    local go_content = string.format([[
package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Printf("🚀 Starting %s...\n")
    fmt.Println("✨ Built with TacoVim Go template")

    numbers := []int{1, 2, 3, 4, 5}
    fmt.Print("Numbers: ")
    for _, num := range numbers {
        fmt.Printf("%%d ", num)
    }
    fmt.Println()

    fmt.Printf("🎉 %s completed successfully!\n")
    fmt.Printf("⏰ Current time: %%s\n", time.Now().Format("2006-01-02 15:04:05"))
}
]], name, name)
    vim.fn.writefile(vim.split(go_content, "\n"), path .. "/main.go")

  elseif tech == "react-vite" then
    vim.fn.system("cd " .. vim.fn.fnamemodify(path, ":h") .. " && npm create vite@latest " .. name .. " -- --template react")

  elseif tech == "nextjs" then
    vim.fn.system("cd " .. vim.fn.fnamemodify(path, ":h") .. " && npx create-next-app@latest " .. name)

  elseif tech == "python-ds" then
    vim.fn.mkdir(path .. "/notebooks", "p")
    vim.fn.mkdir(path .. "/data", "p")
    vim.fn.mkdir(path .. "/src", "p")
    
    local requirements = [[
numpy>=1.21.0
pandas>=1.3.0
matplotlib>=3.4.0
seaborn>=0.11.0
scikit-learn>=1.0.0
jupyter>=1.0.0
]]
    vim.fn.writefile(vim.split(requirements, "\n"), path .. "/requirements.txt")

    local main_py = string.format([[
#!/usr/bin/env python3
"""
%s - Data Science Project
Built with TacoVim
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path

# Set up project paths
PROJECT_ROOT = Path(__file__).parent
DATA_DIR = PROJECT_ROOT / "data"
NOTEBOOKS_DIR = PROJECT_ROOT / "notebooks"

def main():
    print("🚀 Starting %s...")
    print("✨ Built with TacoVim Data Science template")
    
    # Sample data analysis
    data = np.random.randn(100, 2)
    df = pd.DataFrame(data, columns=['x', 'y'])
    
    print(f"📊 Generated sample data with shape: {df.shape}")
    print(df.head())
    
    # Simple plot
    plt.figure(figsize=(8, 6))
    sns.scatterplot(data=df, x='x', y='y')
    plt.title('%s - Sample Data Visualization')
    plt.tight_layout()
    
    # Save plot
    output_path = PROJECT_ROOT / "sample_plot.png"
    plt.savefig(output_path, dpi=300, bbox_inches='tight')
    print(f"📈 Plot saved to: {output_path}")
    
    print("🎉 %s completed successfully!")

if __name__ == "__main__":
    main()
]], name, name, name, name)
    vim.fn.writefile(vim.split(main_py, "\n"), path .. "/main.py")
  end

  -- Create universal project files
  local readme_content = string.format([[# %s

> A professional project created with TacoVim IDE

## 🚀 Getting Started

### Prerequisites
- Make sure you have the required tools installed for your project type

### Installation
```bash
cd %s
# Follow the setup instructions for your specific technology stack
```

### Development with TacoVim
```bash
# Build project
<Space>rb

# Run project
<Space>rr

# Test project
<Space>rt

# Clean project
<Space>rc

# Debug project
<F5>
```

## 🛠️ Built With
- **TacoVim** - Professional Full-Stack Development IDE
- **Modern tooling** - Latest development practices

## 📝 Features
- [ ] Add your features here
- [ ] Modern architecture
- [ ] Production ready

---
*Generated with ❤️ by TacoVim*
]], name, name)

  local gitignore_content = [[# TacoVim Generated .gitignore

# Dependencies
node_modules/
.pnp
.pnp.js

# Build directories
build/
dist/
target/
bin/
obj/
out/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Language specific
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/

# Rust
Cargo.lock

# C/C++
*.o
*.obj
*.exe
*.dll
*.dylib

# Java
*.class
*.jar
*.war

# C#
*.dll
*.exe
*.pdb

# Go
*.exe~

# Zig
zig-cache/
zig-out/

# Haskell
.stack-work/
dist/

# R
.Rhistory
.RData

# Julia
Manifest.toml
]]

  vim.fn.writefile(vim.split(readme_content, "\n"), path .. "/README.md")
  vim.fn.writefile(vim.split(gitignore_content, "\n"), path .. "/.gitignore")

  -- Initialize git
  vim.fn.system("cd " .. path .. " && git init && git add . && git commit -m 'Initial commit: Project created with TacoVim'")

  -- Open the project
  vim.cmd("cd " .. path)
  if pcall(require, "neo-tree") then
    vim.cmd("Neotree toggle")
  end
  vim.notify("🚀 Project '" .. name .. "' created successfully at " .. path, vim.log.levels.INFO)
end

function TacoVim.ProjectManager.recent_projects()
  local projects_file = vim.fn.stdpath("data") .. "/tacovim_projects.txt"
  if vim.fn.filereadable(projects_file) == 1 then
    local projects = vim.fn.readfile(projects_file)
    vim.ui.select(projects, {
      prompt = "📂 Recent projects:",
      format_item = function(item) return "  " .. vim.fn.fnamemodify(item, ":t") .. " (" .. item .. ")" end,
    }, function(choice)
      if choice then
        vim.cmd("cd " .. choice)
        if pcall(require, "neo-tree") then
          vim.cmd("Neotree toggle")
        end
      end
    end)
  else
    vim.notify("No recent projects found", vim.log.levels.WARN)
  end
end

-- =============================================================================
-- BUILD SYSTEM
-- =============================================================================

function TacoVim.BuildSystem.detect_project_type()
  local cwd = vim.fn.getcwd()

  -- .NET projects
  if vim.fn.glob(cwd .. "/*.csproj") ~= "" or vim.fn.glob(cwd .. "/*.sln") ~= "" then
    return "dotnet"
  -- Java projects
  elseif vim.fn.filereadable(cwd .. "/pom.xml") == 1 then
    return "maven"
  elseif vim.fn.filereadable(cwd .. "/build.gradle") == 1 or vim.fn.filereadable(cwd .. "/build.gradle.kts") == 1 then
    return "gradle"
  -- Native languages
  elseif vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
    return "rust"
  elseif vim.fn.filereadable(cwd .. "/build.zig") == 1 then
    return "zig"
  elseif vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
    return "cmake"
  elseif vim.fn.filereadable(cwd .. "/Makefile") == 1 then
    return "make"
  -- Scripting and interpreted languages
  elseif vim.fn.filereadable(cwd .. "/package.json") == 1 then
    return "node"
  elseif vim.fn.filereadable(cwd .. "/go.mod") == 1 then
    return "go"
  elseif vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
    return "python"
  else
    return "unknown"
  end
end

function TacoVim.BuildSystem.build()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet build"
  elseif project_type == "maven" then
    cmd = "mvn compile"
  elseif project_type == "gradle" then
    cmd = "./gradlew build"
  elseif project_type == "rust" then
    cmd = "cargo build --release"
  elseif project_type == "zig" then
    cmd = "zig build"
  elseif project_type == "cmake" then
    cmd = "mkdir -p build && cd build && cmake .. && make -j$(nproc)"
  elseif project_type == "make" then
    cmd = "make"
  elseif project_type == "node" then
    cmd = "npm run build"
  elseif project_type == "go" then
    cmd = "go build -o bin/ ./..."
  elseif project_type == "python" then
    cmd = "python -m build"
  else
    vim.notify("⚠️ Unknown project type for building", vim.log.levels.WARN)
    return
  end

  TacoVim.BuildSystem.run_in_terminal(cmd, "🔨 Building project...")
end

function TacoVim.BuildSystem.run()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

  if project_type == "dotnet" then
    cmd = "dotnet run"
  elseif project_type == "maven" then
    cmd = "mvn exec:java"
  elseif project_type == "gradle" then
    cmd = "./gradlew run"
  elseif project_type == "rust" then
    cmd = "cargo run"
  elseif project_type == "zig" then
    cmd = "zig build run"
  elseif project_type == "cmake" then
    cmd = "mkdir -p build && cd build && cmake .. && make -j$(nproc) && echo '\\n🚀 Running " .. project_name .. "...' && ./" .. project_name
  elseif project_type == "make" then
    cmd = "make && ./" .. project_name
  elseif project_type == "node" then
    cmd = "npm start"
  elseif project_type == "go" then
    cmd = "go run ."
  elseif project_type == "python" then
    if vim.fn.filereadable("main.py") == 1 then
      cmd = "python main.py"
    else
      cmd = "python -m " .. project_name
    end
  else
    vim.notify("⚠️ Unknown project type for running", vim.log.levels.WARN)
    return
  end

  TacoVim.BuildSystem.run_in_terminal(cmd, "🚀 Running project...")
end

function TacoVim.BuildSystem.test()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet test"
  elseif project_type == "maven" then
    cmd = "mvn test"
  elseif project_type == "gradle" then
    cmd = "./gradlew test"
  elseif project_type == "rust" then
    cmd = "cargo test"
  elseif project_type == "zig" then
    cmd = "zig build test"
  elseif project_type == "cmake" then
    cmd = "cd build && make test"
  elseif project_type == "make" then
    cmd = "make test"
  elseif project_type == "node" then
    cmd = "npm test"
  elseif project_type == "go" then
    cmd = "go test ./..."
  elseif project_type == "python" then
    cmd = "python -m pytest"
  else
    vim.notify("⚠️ Unknown project type for testing", vim.log.levels.WARN)
    return
  end

  TacoVim.BuildSystem.run_in_terminal(cmd, "🧪 Running tests...")
end

function TacoVim.BuildSystem.clean()
  local project_type = TacoVim.BuildSystem.detect_project_type()
  local cmd = ""

  if project_type == "dotnet" then
    cmd = "dotnet clean"
  elseif project_type == "maven" then
    cmd = "mvn clean"
  elseif project_type == "gradle" then
    cmd = "./gradlew clean"
  elseif project_type == "rust" then
    cmd = "cargo clean"
  elseif project_type == "zig" then
    cmd = "rm -rf zig-cache zig-out"
  elseif project_type == "cmake" then
    cmd = "rm -rf build/ && echo '🧹 Build directory cleaned!'"
  elseif project_type == "make" then
    cmd = "make clean"
  elseif project_type == "node" then
    cmd = "rm -rf node_modules dist build && npm install"
  elseif project_type == "go" then
    cmd = "go clean -cache && rm -rf bin/"
  elseif project_type == "python" then
    cmd = "rm -rf __pycache__ dist build *.egg-info .pytest_cache && echo '🧹 Python cache cleaned!'"
  else
    vim.notify("⚠️ Unknown project type for cleaning", vim.log.levels.WARN)
    return
  end

  TacoVim.BuildSystem.run_in_terminal(cmd, "🧹 Cleaning project...")
end

function TacoVim.BuildSystem.debug()
  local project_type = TacoVim.BuildSystem.detect_project_type()

  if project_type == "rust" then
    if pcall(require, "rustaceanvim") then
      vim.cmd("RustLsp debuggables")
    else
      require("dap").continue()
    end
  elseif project_type == "zig" then
    vim.fn.system("zig build")
    if vim.v.shell_error == 0 then
      require("dap").continue()
      vim.notify("🐛 Starting Zig debugger...", vim.log.levels.INFO)
    else
      vim.notify("❌ Zig build failed", vim.log.levels.ERROR)
    end
  elseif project_type == "python" then
    if pcall(require, "dap-python") then
      require("dap-python").test_method()
    else
      require("dap").continue()
    end
  elseif project_type == "go" then
    if pcall(require, "dap-go") then
      require("dap-go").debug_test()
    else
      require("dap").continue()
    end
  elseif project_type == "cmake" then
    vim.fn.system("cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make")
    if vim.v.shell_error == 0 then
      require("dap").continue()
    end
  else
    require("dap").continue()
  end
end

function TacoVim.BuildSystem.run_in_terminal(cmd, message)
  vim.notify(message, vim.log.levels.INFO)
  
  -- Try to use toggleterm if available
  local ok, toggleterm = pcall(require, "toggleterm.terminal")
  if ok then
    local Terminal = toggleterm.Terminal
    local term = Terminal:new({
      cmd = cmd,
      direction = "horizontal",
      size = 15,
      close_on_exit = false,
      auto_scroll = true,
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
    })
    term:toggle()
  else
    -- Fallback to regular terminal
    vim.cmd("split")
    vim.cmd("terminal " .. cmd)
    vim.cmd("resize 15")
  end
end

-- =============================================================================
-- THEME MANAGER
-- =============================================================================

local themes = {
  { name = "Catppuccin Mocha", scheme = "catppuccin-mocha" },
  { name = "Catppuccin Latte", scheme = "catppuccin-latte" },
  { name = "Tokyo Night", scheme = "tokyonight" },
  { name = "Tokyo Night Storm", scheme = "tokyonight-storm" },
  { name = "Rose Pine", scheme = "rose-pine" },
  { name = "Kanagawa", scheme = "kanagawa" },
  { name = "Nightfox", scheme = "nightfox" },
  { name = "Gruvbox Material", scheme = "gruvbox-material" },
  { name = "Everforest", scheme = "everforest" },
  { name = "Dracula", scheme = "dracula" },
  { name = "Gruvbox", scheme = "gruvbox" },
  { name = "One Dark", scheme = "onedark" },
  { name = "Nord", scheme = "nord" },
  { name = "Material", scheme = "material" },
  { name = "Nightfly", scheme = "nightfly" },
}

function TacoVim.ThemeManager.switch_theme()
  local theme_names = {}
  for _, theme in ipairs(themes) do
    table.insert(theme_names, theme.name)
  end

  vim.ui.select(theme_names, {
    prompt = "🎨 Select theme:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end

    for _, theme in ipairs(themes) do
      if theme.name == choice then
        local success, error_msg = pcall(vim.cmd.colorscheme, theme.scheme)
        if success then
          vim.notify("🎨 Theme changed to: " .. choice, vim.log.levels.INFO)
          local config_path = vim.fn.stdpath("data") .. "/tacovim_theme.txt"
          pcall(vim.fn.writefile, { theme.scheme }, config_path)
          vim.g.tacovim.theme = theme.scheme

          -- Update lualine theme if available
          local ok, lualine = pcall(require, "lualine")
          if ok then
            pcall(lualine.setup, {
              options = { theme = theme.scheme:match("catppuccin") and "catppuccin" or "auto" }
            })
          end
        else
          vim.notify("❌ Failed to load theme: " .. choice, vim.log.levels.ERROR)
        end
        break
      end
    end
  end)
end

function TacoVim.ThemeManager.get_current_theme()
  return vim.g.tacovim.theme or "catppuccin-mocha"
end

function TacoVim.ThemeManager.get_available_themes()
  return themes
end

-- =============================================================================
-- SESSION MANAGER
-- =============================================================================

function TacoVim.SessionManager.save_session()
  vim.ui.input({
    prompt = "💾 Session name: ",
    default = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
  }, function(name)
    if not name or name == "" then return end

    local ok, persistence = pcall(require, "persistence")
    if ok then
      persistence.save({ name = name })
      vim.notify("💾 Session '" .. name .. "' saved", vim.log.levels.INFO)
    else
      vim.notify("❌ Persistence plugin not available", vim.log.levels.ERROR)
    end
  end)
end

function TacoVim.SessionManager.load_session()
  local ok, persistence = pcall(require, "persistence")
  if ok then
    persistence.load()
    vim.notify("📂 Session restored", vim.log.levels.INFO)
  else
    vim.notify("❌ Persistence plugin not available", vim.log.levels.ERROR)
  end
end

function TacoVim.SessionManager.delete_session()
  local ok, persistence = pcall(require, "persistence")
  if ok then
    persistence.stop()
    vim.notify("🗑️ Session deleted", vim.log.levels.INFO)
  else
    vim.notify("❌ Persistence plugin not available", vim.log.levels.ERROR)
  end
end

-- =============================================================================
-- UTILITIES
-- =============================================================================

function TacoVim.Utilities.toggle_transparency()
  if vim.g.tacovim.transparent_enabled then
    vim.cmd("hi Normal guibg=#1e1e2e")
    vim.cmd("hi NormalFloat guibg=#1e1e2e")
    vim.g.tacovim.transparent_enabled = false
    vim.notify("🎨 Transparency disabled", vim.log.levels.INFO)
  else
    vim.cmd("hi Normal guibg=NONE")
    vim.cmd("hi NormalFloat guibg=NONE")
    vim.g.tacovim.transparent_enabled = true
    vim.notify("🎨 Transparency enabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_diagnostics()
  if vim.g.tacovim.diagnostics_enabled then
    vim.diagnostic.disable()
    vim.g.tacovim.diagnostics_enabled = false
    vim.notify("🔇 Diagnostics disabled", vim.log.levels.INFO)
  else
    vim.diagnostic.enable()
    vim.g.tacovim.diagnostics_enabled = true
    vim.notify("🔊 Diagnostics enabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_format_on_save()
  vim.g.tacovim.auto_format = not vim.g.tacovim.auto_format
  local status = vim.g.tacovim.auto_format and "enabled" or "disabled"
  vim.notify("💾 Format on save " .. status, vim.log.levels.INFO)
end

function TacoVim.Utilities.toggle_line_numbers()
  if vim.wo.number then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.notify("🔢 Line numbers disabled", vim.log.levels.INFO)
  else
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.notify("🔢 Line numbers enabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_wrap()
  vim.wo.wrap = not vim.wo.wrap
  local status = vim.wo.wrap and "enabled" or "disabled"
  vim.notify("📝 Line wrap " .. status, vim.log.levels.INFO)
end

function TacoVim.Utilities.reload_config()
  -- Clear module cache
  for name, _ in pairs(package.loaded) do
    if name:match('^tacovim') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
  vim.notify("🔄 TacoVim configuration reloaded", vim.log.levels.INFO)
end

function TacoVim.Utilities.show_stats()
  local stats_ok, lazy_stats = pcall(require("lazy").stats)
  if not stats_ok then
    vim.notify("❌ Could not get plugin stats", vim.log.levels.ERROR)
    return
  end

  local ms = math.floor(lazy_stats.startuptime * 100 + 0.5) / 100
  local version = vim.version()

  local info = {
    "⚡ TacoVim Statistics",
    "",
    "📦 Plugins: " .. lazy_stats.loaded .. "/" .. lazy_stats.count,
    "⏱️  Startup: " .. ms .. "ms",
    "🎯 Neovim: " .. version.major .. "." .. version.minor .. "." .. version.patch,
    "🎨 Theme: " .. TacoVim.ThemeManager.get_current_theme(),
    "📁 Config: " .. vim.fn.stdpath("config"),
    "💾 Data: " .. vim.fn.stdpath("data"),
    "🗂️  Current: " .. vim.fn.getcwd(),
    "🔧 Build System: " .. TacoVim.BuildSystem.detect_project_type(),
  }

  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "TacoVim Stats" })
end

function TacoVim.Utilities.health_check()
  vim.cmd("checkhealth")
end

function TacoVim.Utilities.create_user_command(name, callback, desc)
  vim.api.nvim_create_user_command(name, callback, { desc = desc })
end

-- =============================================================================
-- USER COMMANDS
-- =============================================================================

-- Register all TacoVim commands
TacoVim.Utilities.create_user_command("TacoVim", function()
  print([[
                                ░░░░░▒░░
                           ░░░░░░░░░░░▒▒▒░░ ░░
                        ░░▒▒▒░▒▒  ░▓▒▓▓▒░░▒▓▒░ ░░
                      ░░░ ░░▒▓▓▒▒▒▒▓▓▓▒░░░░░░░░░░░░░
                    ░▒▓▓▒▒▒▒▒▓▓▓█▓▓▓░░░▒░░░░░░░░░░░░░░░
                   ░▒▒▓▓▒▒▓▓░▒▒▒▒▒░▒░░░░░░░░░░░░▒▒▒░░░░░░░
                  ░░▒▒▓▓▓▓██▓▓▒░░░░░░░░░░░░░░░░▒░░░░░░░░
                  ▒▓▓▓██▓▓▓▓▒░░░░░░░░░░░░░░▒░░░░░░░
                 ░▒▓█▓▓▓█▓░▒░░░░▒░▒░░░▒░░░░░░
                ░▒▓▓▓▓██▓▒░░░░░░░░▒░░░░░░░
                ░▓▒▓██▓░░░░░░░░░░░░
                 ▒▓▓▓░░░▒░░░
                  ░▒░

      🌮 ████████╗ █████╗  ██████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ 🌮
         ╚══██╔══╝██╔══██╗██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
            ██║   ███████║██║     ██║   ██║██║   ██║██║██╔████╔██║
            ██║   ██╔══██║██║     ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
            ██║   ██║  ██║╚██████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

            🚀 Professional Full-Stack Development IDE 🚀
                      Built with ❤️  for developers
]])
  TacoVim.Utilities.show_stats()
end, "Show TacoVim info")

TacoVim.Utilities.create_user_command("TacoVimReload", TacoVim.Utilities.reload_config, "Reload TacoVim configuration")
TacoVim.Utilities.create_user_command("TacoVimTheme", TacoVim.ThemeManager.switch_theme, "Switch TacoVim theme")
TacoVim.Utilities.create_user_command("TacoVimProject", TacoVim.ProjectManager.create_project, "Create new TacoVim project")
TacoVim.Utilities.create_user_command("TacoVimHealth", TacoVim.Utilities.health_check, "Run TacoVim health check")
TacoVim.Utilities.create_user_command("TacoVimBuild", TacoVim.BuildSystem.build, "Build current project")
TacoVim.Utilities.create_user_command("TacoVimRun", TacoVim.BuildSystem.run, "Run current project")
TacoVim.Utilities.create_user_command("TacoVimTest", TacoVim.BuildSystem.test, "Test current project")
TacoVim.Utilities.create_user_command("TacoVimClean", TacoVim.BuildSystem.clean, "Clean current project")

-- Return the module for potential external use
return TacoVim
