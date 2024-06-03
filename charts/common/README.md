# Common Chart for Spark components

---

used for helm charts development only.
Not deployable as a standalone helm chart

##How to use it for chart development:

### step1: add common dependency to your helm chart
```
dependencies:
- name: common
  repository: "file://<path>/common/"
  version: 0.1.0
```
### step2: update the helm dependecy in your chart in your chart directory run the following command: <br>
`` helm dependency update  ``

### step3: use the common functions as per their usage

### step4: after you have finished working on your chart. check in ``Chart.lock`` file as well to git.


## Available functions and their usage:

### Affinities:

| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.nodeAffinity.required` | Returns a required nodeAffinity definition  | `{{ include "common.nodeAffinity.required" . }}` |
| `common.nodeAffinity.preferred`| Returns a preffered nodeAffinity definition |  `{{ include "common.nodeAffinity.preffered" . }}` |
| `common.podAntiAffinity.preferred`| Returns a preffered podAntiAffinity definition | `{{ include "common.podAntiAffinity.preferred" (dict "componentName" "example-name" ) }}` |

### Commands:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.args` | Returns standard args  | `{{ include "common.args" . }}` |
| `common.commands` | Returns standard commands  | `{{ include "common.commands" . }}` |

### Env:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.defaultEnv` | Returns default env for containers  | `{{ include "common.defaultEnv" (dict "containerName" "example-name") }}` |

### Labels:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.labels` | Returns standard labels  | `{{ include "common.labels" (dict "componentName" "example-name" "namespace" "example-ns") }}` |
| `common.selectorLabels` | Returns selector labels  | `{{ include "common.selectorLabels" (dict "componentName" "example-name") }}` |

### Probes:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.probe.liveness` | Returns a liveliness probe  | `{{ include "common.probe.liveness" . }}` |
| `common.probe.readiness` | Returns a readiness probe  | `{{ include "common.probe.readiness" . }}` |
| `common.probe.lifecycle` | Returns a lifecycle (Commonly used for pres-stop) | `{{ include common.probe.lifecycle . }}` |

### Security:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.securityContext` | Returns security context  | `{{ include "common.securityContext" . }}` |

### Toleration:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.tolerations` | Returns ECP tolerations  | `{{ include "common.tolerations" (dict "componentName" "example-name" "namespace" "example-ns") }}` |

### Volume mounts:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.volumeMounts` | Returns standard volume mounts | `{{ include "common.volumeMounts" . }}` |

## Volumes:
| Function name | Description   | Example Usage |
| :----------: |:---------- |:------------|
| `common.volumes` | Returns standard volumes | `{{ include "common.volumes" (dict "configmapName" "example-name" "componentName" "example-component-name") }}` |
