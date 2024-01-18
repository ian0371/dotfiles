Phoenix.set({
  daemon: true,
  openAtLogin: true,
});

const CONTROL_OPTION = ["control", "option"];
const CONTROL_OPTION_COMMAND = ["control", "option", "command"];

Key.on("z", CONTROL_OPTION, () => {
  const screen = Screen.main().frame();
  const window = Window.focused();

  if (window) {
    window.setTopLeft({
      x: screen.x + screen.width / 2 - window.frame().width / 2,
      y: screen.y + screen.height / 2 - window.frame().height / 2,
    });
  }
});

Key.on("return", CONTROL_OPTION, () => {
  const window = Window.focused();

  if (window) {
    window.maximise();
  }
});

function half(key) {
  return () => {
    const window = Window.focused();
    if (!window) {
      return;
    }

    let frame = window.screen().flippedVisibleFrame();
    if (key == "left") {
      frame.width /= 2;
    } else if (key == "right") {
      frame.width /= 2;
      frame.x += frame.width;
    } else if (key == "up") {
      frame.height /= 2;
    } else if (key == "down") {
      frame.height /= 2;
      frame.y += frame.height;
    }

    window.setFrame(frame);
  };
}

Key.on("left", CONTROL_OPTION, half("left"));
Key.on("right", CONTROL_OPTION, half("right"));
Key.on("up", CONTROL_OPTION, half("up"));
Key.on("down", CONTROL_OPTION, half("down"));

function quarter(idx) {
  return () => {
    const window = Window.focused();
    if (!window) {
      return;
    }

    let frame = window.screen().flippedVisibleFrame();
    frame.width /= 2;
    frame.height /= 2;

    if (idx == 2) {
      frame.x += frame.width;
    } else if (idx == 3) {
      frame.y += frame.height;
    } else if (idx == 4) {
      frame.x += frame.width;
      frame.y += frame.height;
    }

    window.setFrame(frame);
  };
}

Key.on("q", CONTROL_OPTION, quarter(1));
Key.on("w", CONTROL_OPTION, quarter(2));
Key.on("a", CONTROL_OPTION, quarter(3));
Key.on("s", CONTROL_OPTION, quarter(4));

function focusOnMain(appName) {
  return () => {
    const app = App.get(appName);
    if (!app) {
      App.launch(appName, { focus: true });
      return;
    }

    for (const window of app.windows()) {
      if (window.screen().identifier() == Screen.main().identifier()) {
        window.focus();
        return;
      }
    }
  };
}

Key.on("1", ["option"], focusOnMain("Finder"));
Key.on("2", ["option"], focusOnMain("Arc"));
Key.on("3", ["option"], focusOnMain("WezTerm"));
Key.on("4", ["option"], focusOnMain("Obsidian"));
Key.on("5", ["option"], focusOnMain("Slack"));

Key.on("right", CONTROL_OPTION_COMMAND, () => {
  const window = Window.focused();
  window.screen().next().currentSpace().moveWindows([window]);
  window.focus();
});

Key.on("left", CONTROL_OPTION_COMMAND, () => {
  const window = Window.focused();
  window.screen().previous().currentSpace().moveWindows([window]);
  window.focus();
});
