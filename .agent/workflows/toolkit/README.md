# 🧰 The Toolkit

The **Toolkit** contains specialized, on-demand workflows that support the Core Golden Path. Unlike the sequential core workflows (0-7), these tools can be pulled off the shelf whenever needed.

## 🗺️ Toolkit Ecosystem

```mermaid
graph TD
    %% --- Styles ---
    classDef setup fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#000;
    classDef quality fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,color:#000;
    classDef delivery fill:#fff3e0,stroke:#ef6c00,stroke-width:2px,color:#000;
    classDef process fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px,color:#000;

    %% --- Nodes ---
    
    subgraph "Setup & Planning"
        NewProject[New Project /new-project]:::setup
        DesignRev[Design Review /design-review]:::setup
    end

    subgraph "Quality & Ops"
        Debug[Debug /debug]:::quality
        Observ[Observability /observability]:::quality
    end

    subgraph "Process Discipline"
        PostTask[Post-Task /post-task]:::process
    end

    subgraph "Delivery & Content"
        Launch[Launch /launch]:::delivery
        Content[Content Prod /content_production]:::delivery
    end

    %% --- Connections (Common Patterns) ---
    NewProject -.-> PostTask
    DesignRev -.-> Observ
    Debug -.-> PostTask
    Launch -.-> Observ
```

---

## 🛠️ Tool Index

### 🔹 Setup & Planning

| Workflow | Command | Purpose |
| :--- | :--- | :--- |
| **[New Project](./new-project.md)** | `/new-project` | Initialize a new repository with the correct `.agent` structure. |
| **[Design Review](./design-review.md)** | `/design-review` | Validate UI/UX designs against requirements before coding. |

### 🔹 Quality & Operations

| Workflow | Command | Purpose |
| :--- | :--- | :--- |
| **[Debug](./debug.md)** | `/debug` | Systematic troubleshooting: Reproduce -> Diagnose -> Fix -> Verify. |
| **[Observability](./observability.md)** | `/observability` | Design metrics, logging, and alerting strategies (The "Golden Signals"). |

### 🔹 Process Discipline

| Workflow | Command | Purpose |
| :--- | :--- | :--- |
| **[Post-Task](./post-task.md)** | `/post-task` | **MANDATORY**. Run this after *every* task to sync documentation and context. |

### 🔹 Delivery & Content

| Workflow | Command | Purpose |
| :--- | :--- | :--- |
| **[Launch](./launch.md)** | `/launch` | The Go-Live checklist (DNS, SEO, Legal, Analytics). |
| **[Content Production](./content_production.md)** | N/A | Waterfall process for high-volume content creation (Video -> Shorts -> Blog). |
