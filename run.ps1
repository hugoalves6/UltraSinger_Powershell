# Activate the Python Virtual Environment
.venv\Scripts\activate

# Change directory to src
cd src

# Get GPU memory in GB
$gpuMemoryGB = (Get-WmiObject Win32_VideoController | Select-Object -ExpandProperty AdapterRAM)[0] / 1GB -as [int]

# Display GPU memory and available Whisper model options
Write-Host "Your GPU memory is $gpuMemoryGB GB. Available Whisper model options for your GPU:"

# Determine the appropriate Whisper model options based on GPU memory
switch ($gpuMemoryGB) {
    { $_ -lt 1 } { $availableModels = @("tiny (512MB)") }
    { $_ -ge 1 -and $_ -lt 2 } { $availableModels = @("tiny (512MB)", "base (1GB)") }
    { $_ -ge 2 -and $_ -lt 4 } { $availableModels = @("tiny (512MB)", "base (1GB)", "small (2GB)") }
    { $_ -ge 4 -and $_ -lt 5 } { 
        $availableModels = @("tiny (512MB)", "base (1GB)", "small (2GB)", "medium (5GB) [Warning: may fail]")
    }
    { $_ -ge 5 -and $_ -lt 10 } { $availableModels = @("tiny (512MB)", "base (1GB)", "small (2GB)", "medium (5GB)", "large-v1 (10GB)") }
    { $_ -ge 10 } { $availableModels = @("tiny (512MB)", "base (1GB)", "small (2GB)", "medium (5GB)", "large-v1 (10GB)", "large-v2 (10GB)") }
    Default { $availableModels = @() }
}

# Display available models
$availableModels | ForEach-Object { Write-Host $_ }

# Ask user to choose a Whisper model
$whisperModel = Read-Host "Please choose a Whisper model from the above options"

# Get YouTube link from user
$youtubeLink = Read-Host "Please enter the YouTube video link"

# Get current directory
$currentDir = Get-Location

# Ask user for output folder, show current directory as default
$outputFolder = Read-Host "Enter output folder (default: $currentDir\output)"
if ($outputFolder -eq "") {
    $outputFolder = "$currentDir\output"
}

# Run UltraSinger with the specified parameters
py UltraSinger.py --whisper $whisperModel -i $youtubeLink -o $outputFolder

# Pause at the end
Pause
