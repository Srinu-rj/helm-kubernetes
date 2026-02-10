import subprocess
import os
import time

# Configuration
GITHUB_REPO_URL = "https://github.com/RohanRusta21/Weather-App.git"
DOCKER_IMAGE_NAME = "ttl.sh/weather-app-demo"
DOCKER_IMAGE_TAG = "10h"
TRIVY_REPORT = "my-report.txt"


def checkout_code():
    """Clone the source code from GitHub."""
    print("📥 Cloning repository...")
    if os.path.exists("repository"):
        print("⚠️ Repository already exists, removing it first before cloning...")
        subprocess.run(["rm", "-rf", "repository"], check=True)

    subprocess.run(["git", "clone", GITHUB_REPO_URL, "repository"], check=True)
    print("✅ Repository cloned successfully.")


def build_docker_image():
    """Build a Docker image from the source code."""
    print("🐳 Building Docker image...")
    os.chdir("repository")
    if not os.path.exists("Dockerfile"):
        raise Exception("❌ Dockerfile not found in the repository!")

    subprocess.run(["docker", "build", "-t", f"{DOCKER_IMAGE_NAME}:{DOCKER_IMAGE_TAG}", "."], check=True)
    print(f"✅ Docker image {DOCKER_IMAGE_NAME}:{DOCKER_IMAGE_TAG} built successfully.")

    os.chdir("..")  # Go back to the original directory


def install_trivy():
    """Install Trivy if not already installed."""
    try:
        subprocess.run(["trivy", "--version"], check=True, stdout=subprocess.DEVNULL)
        print("✅ Trivy is already installed.")
    except subprocess.CalledProcessError:
        print("🔍 Installing Trivy security scanner...")
        subprocess.run(["wget", "https://github.com/aquasecurity/trivy/releases/latest/download/trivy_Linux-64bit.deb"], check=True)
        subprocess.run(["sudo", "dpkg", "-i", "trivy_Linux-64bit.deb"], check=True)
        print("✅ Trivy installed successfully.")


def scan_docker_image():
    """Scan the Docker image for vulnerabilities using Trivy."""
    print("🔎 Scanning Docker image using Trivy...")
    with open(TRIVY_REPORT, "w") as report_file:
        subprocess.run(["trivy", "image", f"{DOCKER_IMAGE_NAME}:{DOCKER_IMAGE_TAG}"], stdout=report_file, check=True)

    print(f"✅ Trivy scan completed. Report saved to {TRIVY_REPORT}.")


def run_docker_image():
    """Run the built Docker image."""
    print("🚀 Running Docker container...")
    subprocess.run(["docker", "run", "-it", "-p", "3011:3000", f"{DOCKER_IMAGE_NAME}:{DOCKER_IMAGE_TAG}"], check=True)
    print(f"✅ Docker container {DOCKER_IMAGE_NAME}:{DOCKER_IMAGE_TAG} is running.")


def main():
    """Main function to execute the CI/CD pipeline."""
    try:
        # Step 1: Checkout source code
        checkout_code()

        # Step 2: Build Docker image
        build_docker_image()

        # Step 3: Install Trivy
        install_trivy()

        # Step 4: Scan with Trivy
        scan_docker_image()

        # Step 5: Run Docker image
        run_docker_image()

        print("🎉 CI/CD pipeline executed successfully!")
    except Exception as e:
        print(f"❌ Pipeline failed: {e}")
        exit(1)


if __name__ == "__main__":
    main()