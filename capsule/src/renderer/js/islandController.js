// Dynamic Island State Controller
class IslandController {
  constructor(islandElem) {
    this.islandElem = islandElem;
    this.currentState = 'idle'; // 'idle' | 'hover' | 'expanded' | 'max-expand'
    this.init();
  }

  init() {
    // Initial pass-through configuration
    if (window.capsuleAPI?.setIgnoreMouseEvents) {
      window.capsuleAPI.setIgnoreMouseEvents(true, { forward: true });
    }

    // Mouse Enter Island
    this.islandElem.addEventListener('mouseenter', () => {
      if (window.capsuleAPI?.setIgnoreMouseEvents) {
        window.capsuleAPI.setIgnoreMouseEvents(false);
      }
      if (this.currentState === 'idle') {
        this.setState('hover');
      }
    });

    // Mouse Leave Island
    this.islandElem.addEventListener('mouseleave', () => {
      if (this.currentState === 'hover') {
        this.setState('idle');
        if (window.capsuleAPI?.setIgnoreMouseEvents) {
          window.capsuleAPI.setIgnoreMouseEvents(true, { forward: true });
        }
      } else if (this.currentState === 'idle') {
        if (window.capsuleAPI?.setIgnoreMouseEvents) {
          window.capsuleAPI.setIgnoreMouseEvents(true, { forward: true });
        }
      }
    });

    // Click to Expand from Hover/Idle
    this.islandElem.addEventListener('click', (e) => {
      // Don't trigger if user clicked an explicit button or input
      if (e.target.closest('button') || e.target.closest('input')) return;

      if (this.currentState === 'idle' || this.currentState === 'hover') {
        this.setState('expanded');
      }
    });

    // Tray toggle event
    if (window.capsuleAPI?.onToggleIslandState) {
      window.capsuleAPI.onToggleIslandState(() => {
        if (this.currentState === 'idle' || this.currentState === 'hover') {
          this.setState('expanded');
        } else {
          this.setState('idle');
          if (window.capsuleAPI?.setIgnoreMouseEvents) {
            window.capsuleAPI.setIgnoreMouseEvents(true, { forward: true });
          }
        }
      });
    }
  }

  setState(newState) {
    this.islandElem.classList.remove('state-idle', 'state-hover', 'state-expanded', 'state-max-expand');
    this.islandElem.classList.add(`state-${newState}`);
    this.currentState = newState;

    if (newState === 'expanded' || newState === 'max-expand') {
      if (window.capsuleAPI?.setIgnoreMouseEvents) {
        window.capsuleAPI.setIgnoreMouseEvents(false);
      }
    }
  }

  collapseToIdle() {
    this.setState('idle');
    if (window.capsuleAPI?.setIgnoreMouseEvents) {
      window.capsuleAPI.setIgnoreMouseEvents(true, { forward: true });
    }
  }
}

window.IslandController = IslandController;
