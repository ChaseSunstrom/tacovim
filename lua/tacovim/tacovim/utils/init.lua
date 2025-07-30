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

  -- Save to recent projects
  TacoVim.ProjectManager.add_to_recent_projects(path)
  
  -- Open the project
  vim.cmd("cd " .. path)
  if pcall(require, "neo-tree") then
    vim.cmd("Neotree toggle")
  end
  vim.notify("🚀 Project '" .. name .. "' created successfully at " .. path, vim.log.levels.INFO)
end

function TacoVim.ProjectManager.add_to_recent_projects(path)
  local projects_file = vim.fn.stdpath("data") .. "/tacovim_projects.txt"
  local projects = {}
  
  -- Read existing projects if file exists
  if vim.fn.filereadable(projects_file) == 1 then
    projects = vim.fn.readfile(projects_file)
  end
  
  -- Remove if already exists (to move to top)
  for i, project in ipairs(projects) do
    if project == path then
      table.remove(projects, i)
      break
    end
  end
  
  -- Add to beginning
  table.insert(projects, 1, path)
  
  -- Keep only last 10 projects
  if #projects > 10 then
    local trimmed = {}
    for i = 1, 10 do
      trimmed[i] = projects[i]
    end
    projects = trimmed
  end
  
  -- Save to file
  vim.fn.writefile(projects, projects_file)
end

function TacoVim.ProjectManager.recent_projects()
  local projects_file = vim.fn.stdpath("data") .. "/tacovim_projects.txt"
  
  -- Debug: Check if file exists and its content
  if vim.fn.filereadable(projects_file) == 1 then
    local projects = vim.fn.readfile(projects_file)
    
    if #projects == 0 then
      vim.notify("Recent projects file is empty. Try creating a project first!", vim.log.levels.WARN)
      return
    end
    
    vim.ui.select(projects, {
      prompt = "📂 Recent projects (" .. #projects .. " found):",
      format_item = function(item) 
        local name = vim.fn.fnamemodify(item, ":t")
        return "  " .. name .. " (" .. item .. ")" 
      end,
    }, function(choice)
      if choice then
        -- Add this project to recent list when accessed
        TacoVim.ProjectManager.add_to_recent_projects(choice)
        vim.cmd("cd " .. vim.fn.fnameescape(choice))
        if pcall(require, "neo-tree") then
          vim.cmd("Neotree toggle")
        end
        vim.notify("📁 Opened project: " .. vim.fn.fnamemodify(choice, ":t"), vim.log.levels.INFO)
      end
    end)
  else
    local choice = vim.fn.confirm(
      "No recent projects found.\n" ..
      "Would you like to:\n" ..
      "1. Create a new project\n" ..
      "2. Add current directory to recent projects\n" ..
      "3. Cancel", 
      "&Create\n&Add Current\n&Cancel", 
      1
    )
    
    if choice == 1 then
      TacoVim.ProjectManager.create_project()
    elseif choice == 2 then
      local current_dir = vim.fn.getcwd()
      TacoVim.ProjectManager.add_to_recent_projects(current_dir)
      vim.notify("Added current directory to recent projects!", vim.log.levels.INFO)
    end
  end
end

-- Add function to manually add current directory to recent projects
function TacoVim.ProjectManager.add_current_to_recent()
  local current_dir = vim.fn.getcwd()
  TacoVim.ProjectManager.add_to_recent_projects(current_dir)
  vim.notify("📁 Added current directory to recent projects: " .. vim.fn.fnamemodify(current_dir, ":t"), vim.log.levels.INFO)
end

-- Switch between recent projects
function TacoVim.ProjectManager.switch_project()
  local projects_file = vim.fn.stdpath("data") .. "/tacovim_projects.txt"
  
  if vim.fn.filereadable(projects_file) == 0 then
    vim.notify("📁 No recent projects found", vim.log.levels.WARN)
    return
  end
  
  local recent_projects = vim.fn.readfile(projects_file)
  if #recent_projects == 0 then
    vim.notify("📁 No recent projects found", vim.log.levels.WARN)
    return
  end
  
  local display_projects = {}
  for _, project in ipairs(recent_projects) do
    table.insert(display_projects, vim.fn.fnamemodify(project, ":t") .. " (" .. project .. ")")
  end
  
  vim.ui.select(display_projects, {
    prompt = "🚀 Switch to project:",
    format_item = function(item) return "  " .. item end,
  }, function(choice, idx)
    if choice and idx then
      local project_path = recent_projects[idx]
      if vim.fn.isdirectory(project_path) == 1 then
        vim.cmd("cd " .. vim.fn.fnameescape(project_path))
        vim.notify("🚀 Switched to project: " .. vim.fn.fnamemodify(project_path, ":t"), vim.log.levels.INFO)
      else
        vim.notify("❌ Project directory does not exist: " .. project_path, vim.log.levels.ERROR)
      end
    end
  end)
end

-- Delete project from recent projects list
function TacoVim.ProjectManager.delete_project()
  local projects_file = vim.fn.stdpath("data") .. "/tacovim_projects.txt"
  
  if vim.fn.filereadable(projects_file) == 0 then
    vim.notify("📁 No recent projects found", vim.log.levels.WARN)
    return
  end
  
  local recent_projects = vim.fn.readfile(projects_file)
  if #recent_projects == 0 then
    vim.notify("📁 No recent projects found", vim.log.levels.WARN)
    return
  end
  
  local display_projects = {}
  for _, project in ipairs(recent_projects) do
    table.insert(display_projects, vim.fn.fnamemodify(project, ":t") .. " (" .. project .. ")")
  end
  
  vim.ui.select(display_projects, {
    prompt = "🗑️ Remove from recent projects:",
    format_item = function(item) return "  " .. item end,
  }, function(choice, idx)
    if choice and idx then
      local project_path = recent_projects[idx]
      table.remove(recent_projects, idx)
      
      -- Save updated list
      vim.fn.writefile(recent_projects, projects_file)
      vim.notify("🗑️ Removed from recent projects: " .. vim.fn.fnamemodify(project_path, ":t"), vim.log.levels.INFO)
    end
  end)
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

-- Enhanced utility functions for the new keymap system
function TacoVim.Utilities.toggle_transparency()
  local current_bg = vim.api.nvim_get_hl_by_name("Normal", true).background
  if current_bg then
    vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.notify("🌟 Transparency enabled", vim.log.levels.INFO)
  else
    vim.cmd("colorscheme " .. (vim.g.colors_name or "default"))
    vim.notify("🎨 Transparency disabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_format_on_save()
  local status = not vim.g.tacovim_format_on_save
  vim.g.tacovim_format_on_save = status
  
  if status then
    vim.notify("✨ Format on save enabled", vim.log.levels.INFO)
  else
    vim.notify("⏸️ Format on save disabled", vim.log.levels.INFO)
  end
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
  if vim.wo.wrap then
    vim.notify("📝 Line wrap enabled", vim.log.levels.INFO)
  else
    vim.notify("📏 Line wrap disabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.toggle_diagnostics()
  if vim.diagnostic.is_disabled() then
    vim.diagnostic.enable()
    vim.notify("🩺 Diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.disable()
    vim.notify("🙈 Diagnostics disabled", vim.log.levels.INFO)
  end
end

function TacoVim.Utilities.smart_quit()
  local buffers = vim.api.nvim_list_bufs()
  local modified_buffers = {}
  
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'modified') then
      table.insert(modified_buffers, buf)
    end
  end
  
  if #modified_buffers > 0 then
    local choice = vim.fn.confirm("Save modified buffers before quitting?", "&Yes\n&No\n&Cancel", 1)
    if choice == 1 then
      vim.cmd("wa")
      vim.cmd("qa")
    elseif choice == 2 then
      vim.cmd("qa!")
    end
  else
    vim.cmd("qa")
  end
end

function TacoVim.Utilities.duplicate_line()
  local line = vim.api.nvim_get_current_line()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, {line})
  vim.api.nvim_win_set_cursor(0, {row + 1, 0})
end

function TacoVim.Utilities.center_buffer()
  local height = vim.api.nvim_win_get_height(0)
  local lines = vim.api.nvim_buf_line_count(0)
  local empty_lines = math.floor((height - lines) / 2)
  
  if empty_lines > 0 then
    local padding = {}
    for _ = 1, empty_lines do
      table.insert(padding, "")
    end
    vim.api.nvim_buf_set_lines(0, 0, 0, false, padding)
  end
end

-- =============================================================================
-- KEYMAP MANAGEMENT UI
-- =============================================================================

function TacoVim.Utilities.keymap_manager()
  local keymaps = vim.api.nvim_get_keymap('n')  -- Get normal mode keymaps
  local custom_keymaps = {}
  
  -- Filter for custom TacoVim keymaps (those starting with leader)
  for _, keymap in ipairs(keymaps) do
    if keymap.lhs and keymap.lhs:match("^<Space>") or keymap.lhs:match("^<leader>") then
      table.insert(custom_keymaps, {
        lhs = keymap.lhs,
        rhs = keymap.rhs or keymap.callback and "[function]" or "",
        desc = keymap.desc or "No description",
        buffer = keymap.buffer,
        mode = "n"
      })
    end
  end
  
  -- Sort by key
  table.sort(custom_keymaps, function(a, b) return a.lhs < b.lhs end)
  
  local actions = {
    "📋 View All Keymaps",
    "🔍 Search Keymaps", 
    "➕ Add New Keymap",
    "🗑️ Remove Keymap",
    "📁 Export Keymaps",
    "📥 Import Keymaps",
    "🔄 Reset to Defaults"
  }
  
  vim.ui.select(actions, {
    prompt = "🎹 TacoVim Keymap Manager:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end
    
    if choice:match("View All") then
      TacoVim.Utilities.show_all_keymaps(custom_keymaps)
    elseif choice:match("Search") then
      TacoVim.Utilities.search_keymaps(custom_keymaps)
    elseif choice:match("Add New") then
      TacoVim.Utilities.add_new_keymap()
    elseif choice:match("Remove") then
      TacoVim.Utilities.remove_keymap(custom_keymaps)
    elseif choice:match("Export") then
      TacoVim.Utilities.export_keymaps(custom_keymaps)
    elseif choice:match("Import") then
      TacoVim.Utilities.import_keymaps()
    elseif choice:match("Reset") then
      TacoVim.Utilities.reset_keymaps()
    end
  end)
end

function TacoVim.Utilities.show_all_keymaps(keymaps)
  local lines = { "# TacoVim Keymaps", "", "| Key | Action | Description |", "|-----|--------|-------------|" }
  
  for _, keymap in ipairs(keymaps) do
    local key = keymap.lhs:gsub("<leader>", "<Space>"):gsub("<Space>", "SPC")
    local action = vim.fn.strtrans(keymap.rhs):sub(1, 30)
    local desc = keymap.desc:sub(1, 40)
    table.insert(lines, string.format("| `%s` | %s | %s |", key, action, desc))
  end
  
  table.insert(lines, "")
  table.insert(lines, "Total keymaps: " .. #keymaps)
  
  -- Create a temporary buffer to show the keymaps
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(buf, 'readonly', true)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.8)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " TacoVim Keymaps ",
    title_pos = "center"
  })
  
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
end

function TacoVim.Utilities.search_keymaps(keymaps)
  vim.ui.input({ prompt = "🔍 Search keymaps: " }, function(query)
    if not query or query == "" then return end
    
    local filtered = {}
    query = query:lower()
    
    for _, keymap in ipairs(keymaps) do
      if keymap.lhs:lower():match(query) or 
         keymap.desc:lower():match(query) or
         keymap.rhs:lower():match(query) then
        table.insert(filtered, keymap)
      end
    end
    
    if #filtered == 0 then
      vim.notify("No keymaps found matching: " .. query, vim.log.levels.WARN)
    else
      TacoVim.Utilities.show_all_keymaps(filtered)
    end
  end)
end

function TacoVim.Utilities.add_new_keymap()
  vim.ui.input({ prompt = "🎹 Enter key combination (e.g., <leader>xy): " }, function(key)
    if not key or key == "" then return end
    
    vim.ui.input({ prompt = "⚡ Enter command/action: " }, function(action)
      if not action or action == "" then return end
      
      vim.ui.input({ prompt = "📝 Enter description: " }, function(desc)
        if not desc then desc = "Custom keymap" end
        
        -- Add the keymap
        vim.keymap.set('n', key, action, { desc = desc, silent = true })
        vim.notify("✅ Added keymap: " .. key .. " → " .. action, vim.log.levels.INFO)
        
        -- Optionally save to file
        local choice = vim.fn.confirm("Save this keymap permanently?", "&Yes\n&No", 1)
        if choice == 1 then
          TacoVim.Utilities.save_custom_keymap(key, action, desc)
        end
      end)
    end)
  end)
end

function TacoVim.Utilities.save_custom_keymap(key, action, desc)
  local config_path = vim.fn.stdpath("config") .. "/lua/tacovim/custom_keymaps.lua"
  local keymap_line = string.format('vim.keymap.set("n", "%s", "%s", { desc = "%s", silent = true })', key, action, desc)
  
  local file = io.open(config_path, "a")
  if file then
    file:write(keymap_line .. "\n")
    file:close()
    vim.notify("💾 Keymap saved to " .. config_path, vim.log.levels.INFO)
  else
    vim.notify("❌ Failed to save keymap", vim.log.levels.ERROR)
  end
end

function TacoVim.Utilities.export_keymaps(keymaps)
  local export_data = {}
  for _, keymap in ipairs(keymaps) do
    table.insert(export_data, {
      key = keymap.lhs,
      action = keymap.rhs,
      desc = keymap.desc,
      mode = keymap.mode
    })
  end
  
  local json_str = vim.fn.json_encode(export_data)
  local export_file = vim.fn.stdpath("data") .. "/tacovim_keymaps_export.json"
  
  vim.fn.writefile(vim.split(json_str, "\n"), export_file)
  vim.notify("📁 Keymaps exported to: " .. export_file, vim.log.levels.INFO)
end

-- =============================================================================
-- TABS VS BUFFERS EXPLANATION AND MANAGEMENT
-- =============================================================================

function TacoVim.Utilities.explain_tabs_vs_buffers()
  local explanation = {
    "# 📑 Tabs vs 🗂️ Buffers in Neovim",
    "",
    "## 🗂️ BUFFERS (Most Important)",
    "• Buffers are the FILES loaded in memory",
    "• Each open file = one buffer",
    "• Examples: main.zig, build.zig, config.lua",
    "• Use: <Tab>/<S-Tab> to switch between buffers",
    "• Think: 'Different documents on your desk'",
    "",
    "## 📑 TABS (Less Common)",
    "• Tabs are WORKSPACES that can contain multiple windows",
    "• Each tab can have different window layouts",
    "• Examples: Tab 1 (main work), Tab 2 (debugging), Tab 3 (docs)",
    "• Use: <leader><tab>n/<leader><tab>p to switch tabs",
    "• Think: 'Different desks in your office'",
    "",
    "## 🎯 PRACTICAL USAGE",
    "• Most developers use BUFFERS for file switching",
    "• Use TABS for different project contexts or workflows",
    "• Tabs are like virtual desktops for your code",
    "",
    "## 📊 CURRENT STATUS",
    "• Open buffers: " .. #vim.api.nvim_list_bufs() .. " files",
    "• Current tabs: " .. vim.fn.tabpagenr('$') .. " workspaces",
    "• Active buffer: " .. (vim.fn.expand('%:t') ~= '' and vim.fn.expand('%:t') or '[No Name]'),
    "• Current tab: " .. vim.fn.tabpagenr(),
    "",
    "## 🔧 QUICK COMMANDS",
    "• <Tab> / <S-Tab> → Switch buffers (recommended)",
    "• <leader><tab>o → New tab workspace",  
    "• <leader><tab>x → Close current tab",
    "• <leader>bd → Close current buffer/file",
    "• <leader>bo → Close all other buffers",
    "",
    "💡 TIP: Use buffers for files, tabs for workflows!"
  }
  
  -- Create a temporary buffer to show the explanation
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, explanation)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
  vim.api.nvim_buf_set_option(buf, 'readonly', true)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.8)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2)
  local col = math.ceil((width - win_width) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = " 📑 Tabs vs 🗂️ Buffers Guide ",
    title_pos = "center"
  })
  
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<cr>', { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', '<cmd>close<cr>', { noremap = true, silent = true })
end

function TacoVim.Utilities.buffer_manager()
  local buffers = vim.api.nvim_list_bufs()
  local valid_buffers = {}
  
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') then
      local name = vim.api.nvim_buf_get_name(buf)
      local display_name = name ~= '' and vim.fn.fnamemodify(name, ':t') or '[No Name]'
      local modified = vim.api.nvim_buf_get_option(buf, 'modified') and ' [+]' or ''
      table.insert(valid_buffers, {
        buf = buf,
        name = display_name .. modified,
        path = name
      })
    end
  end
  
  if #valid_buffers == 0 then
    vim.notify("No buffers found", vim.log.levels.WARN)
    return
  end
  
  local items = {}
  for _, buffer in ipairs(valid_buffers) do
    table.insert(items, buffer.name)
  end
  
  vim.ui.select(items, {
    prompt = "🗂️ Buffer Manager (" .. #valid_buffers .. " buffers):",
    format_item = function(item) return "  " .. item end,
  }, function(choice, idx)
    if choice and idx then
      vim.api.nvim_set_current_buf(valid_buffers[idx].buf)
    end
  end)
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

-- =============================================================================
-- ADVANCED SEARCH UTILITIES
-- =============================================================================

TacoVim.Search = {}

-- Interactive search and replace
function TacoVim.Search.interactive_search_replace()
  local search_options = {
    "🔍 Search word under cursor",
    "📝 Custom search pattern",
    "📁 Search in files by type",
    "🌐 Project-wide search",
    "🔄 Search and replace current buffer",
    "🔄 Search and replace all files",
    "📋 Search in clipboard",
    "🏷️ Search by tags/symbols",
  }

  vim.ui.select(search_options, {
    prompt = "🔍 Advanced Search Options:",
    format_item = function(item) return "  " .. item end,
  }, function(choice)
    if not choice then return end

    if choice:match("word under cursor") then
      local word = vim.fn.expand("<cword>")
      if word ~= "" then
        require('telescope.builtin').live_grep({ default_text = word })
      end
      
    elseif choice:match("Custom search") then
      require('telescope.builtin').live_grep()
      
    elseif choice:match("files by type") then
      TacoVim.Search.search_by_filetype()
      
    elseif choice:match("Project-wide") then
      require('telescope.builtin').live_grep({
        additional_args = {"--hidden", "--no-ignore"}
      })
      
    elseif choice:match("replace current buffer") then
      TacoVim.Search.buffer_search_replace()
      
    elseif choice:match("replace all files") then
      TacoVim.Search.project_search_replace()
      
    elseif choice:match("clipboard") then
      local clipboard = vim.fn.getreg("+")
      if clipboard ~= "" then
        require('telescope.builtin').live_grep({ default_text = clipboard })
      end
      
    elseif choice:match("tags/symbols") then
      require('telescope.builtin').treesitter()
    end
  end)
end

-- Search by file type
function TacoVim.Search.search_by_filetype()
  local filetypes = {
    { "Lua files", "lua" },
    { "Python files", "py" },
    { "JavaScript/TypeScript", "js,ts,jsx,tsx" },
    { "Zig files", "zig" },
    { "C/C++ files", "c,cpp,h,hpp" },
    { "Rust files", "rs" },
    { "Go files", "go" },
    { "JSON files", "json" },
    { "YAML files", "yaml,yml" },
    { "Markdown files", "md" },
    { "Configuration files", "conf,config,ini,toml" },
  }

  vim.ui.select(filetypes, {
    prompt = "📁 Select file type to search:",
    format_item = function(item) return "  " .. item[1] end,
  }, function(choice)
    if choice then
      local extensions = vim.split(choice[2], ",")
      local args = {}
      for _, ext in ipairs(extensions) do
        table.insert(args, "--type")
        table.insert(args, ext)
      end
      
      require('telescope.builtin').live_grep({
        additional_args = function() return args end,
      })
    end
  end)
end

-- Buffer search and replace
function TacoVim.Search.buffer_search_replace()
  local search = vim.fn.input("Search in current buffer: ")
  if search == "" then return end
  
  local replace = vim.fn.input("Replace with: ")
  if replace == "" then return end
  
  local confirm = vim.fn.confirm("Replace '" .. search .. "' with '" .. replace .. "' in current buffer?", "&Yes\n&No", 2)
  if confirm == 1 then
    vim.cmd(":%s/" .. vim.fn.escape(search, '/\\') .. "/" .. vim.fn.escape(replace, '/\\') .. "/gc")
  end
end

-- Project-wide search and replace
function TacoVim.Search.project_search_replace()
  local search = vim.fn.input("Search in all project files: ")
  if search == "" then return end
  
  -- First, show preview of files that contain the search term
  require('telescope.builtin').live_grep({
    default_text = search,
    prompt_title = "Files containing '" .. search .. "'",
  })
  
  vim.notify(
    "📝 To replace across files:\n" ..
    "1. Select files in Telescope (use Tab to mark multiple)\n" ..
    "2. Send to quickfix with <C-q>\n" ..
    "3. Run: :cfdo %s/" .. search .. "/REPLACEMENT/gc | update",
    vim.log.levels.INFO
  )
end

-- Search utility commands
TacoVim.Utilities.create_user_command("TacoSearch", TacoVim.Search.interactive_search_replace, "Advanced search interface")

-- =============================================================================
-- DEBUGGING UTILITIES
-- =============================================================================

TacoVim.Debug = TacoVim.Debug or {}

-- Reload DAP configuration
function TacoVim.Debug.reload_dap()
  pcall(function()
    -- Reload DAP configuration
    package.loaded["dap"] = nil
    package.loaded["dapui"] = nil
    require("dap")
    require("dapui")
    vim.notify("🔄 DAP configuration reloaded", vim.log.levels.INFO)
  end)
end

-- Fix DAP UI issues
function TacoVim.Debug.fix_dap_ui()
  pcall(function()
    local dapui = require("dapui")
    dapui.close()
    vim.defer_fn(function()
      dapui.open()
      vim.notify("🔧 DAP UI refreshed", vim.log.levels.INFO)
    end, 500)
  end)
end

-- Terminate debug session completely
function TacoVim.Debug.terminate_session()
  pcall(function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- Close all debug windows
    dapui.close()
    
    -- Terminate the session
    if dap.session() then
      dap.terminate()
      vim.notify("🛑 Debug session terminated", vim.log.levels.INFO)
    else
      vim.notify("ℹ️ No active debug session", vim.log.levels.INFO)
    end
    
    -- Clear any remaining DAP state
    vim.defer_fn(function()
      dap.close()
    end, 100)
  end)
end

-- Quick debug session status
function TacoVim.Debug.session_status()
  pcall(function()
    local dap = require("dap")
    local session = dap.session()
    if session then
      vim.notify("🐛 Debug session active: " .. (session.config.name or "Unknown"), vim.log.levels.INFO)
    else
      vim.notify("ℹ️ No active debug session", vim.log.levels.INFO)
    end
  end)
end

-- Debug commands
TacoVim.Utilities.create_user_command("TacoDebugReload", TacoVim.Debug.reload_dap, "Reload DAP configuration")
TacoVim.Utilities.create_user_command("TacoDebugFixUI", TacoVim.Debug.fix_dap_ui, "Fix DAP UI issues")
TacoVim.Utilities.create_user_command("TacoDebugTerminate", TacoVim.Debug.terminate_session, "Terminate debug session completely")
TacoVim.Utilities.create_user_command("TacoDebugStatus", TacoVim.Debug.session_status, "Show debug session status")

-- Return the module for potential external use
return TacoVim
