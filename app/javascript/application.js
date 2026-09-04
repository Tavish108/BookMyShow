// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


function startOtpTimer() {
  const countdown = document.getElementById("countdown");
  const timer = document.getElementById("otp-timer");
  const resendButton = document.getElementById("resend-button");
  const resendMessage = document.getElementById("resend-message");

  if (!countdown || !timer || !resendButton || !resendMessage) return;

  const otpSentAt = new Date(
    countdown.dataset.otpSentAt
  ).getTime();

  if (Number.isNaN(otpSentAt)) return;

  const resendAt = otpSentAt + 0.5 * 60 * 1000;

  resendButton.classList.add("hidden");
  resendMessage.classList.add("hidden");
  timer.classList.remove("hidden");

  function updateTimer() {
    const remaining = resendAt - Date.now();

    if (remaining <= 0) {
      countdown.textContent = "0:00";

      timer.classList.add("hidden");
      resendMessage.classList.remove("hidden");
      resendButton.classList.remove("hidden");

      return;
    }

    const totalSeconds = Math.ceil(remaining / 1000);

    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;

    countdown.textContent =
      `${minutes}:${String(seconds).padStart(2, "0")}`;

    setTimeout(updateTimer, 1000);
  }

  updateTimer();
}

document.addEventListener("turbo:load", startOtpTimer);