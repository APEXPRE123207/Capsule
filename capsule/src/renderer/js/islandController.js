// Dynamic Island State Controller
class IslandController {
  constructor(islandElem) {
    this.islandElem = islandElem;
    this.currentState = 'idle'; // 'idle' | 'hover' | 'expanded' | 'max-expand'
    this.init();
  }

  init() {
    // Mouse Enter Island
    this.islandElem.addEventListener('mouseenter', () => {
      if (this.currentState === 'idle') {
        this.setState('hover');
      }
    });

    // Mouse Leave Island
    this.islandElem.addEventListener('mouseleave', () => {
      if (this.currentState === 'hover') {
        this.setState('idle');
      }
    });

    // Click to Expand from Hover/Idle
    this.islandElem.addEventListener('click', (e) => {
      // Don't trigger if user clicked an explicit button, input, or interactive child
      if (e.target.closest('button') || e.target.closest('input')) return;

      if (this.currentState === 'idle' || this.currentState === 'hover') {
        this.setState('expanded');
      }
    });

    // Listen for force-idle-state from main process
    if (window.capsuleAPI?.onForceIdleState) {
      window.capsuleAPI.onForceIdleState(() => {
        this.collapseToIdle();
      });
    }

    // Tray toggle event
    if (window.capsuleAPI?.onToggleIslandState) {
      window.capsuleAPI.onToggleIslandState(() => {
        if (this.currentState === 'idle' || this.currentState === 'hover') {
          this.setState('expanded');
        } else {
          this.collapseToIdle();
        }
      });
    }
  }

  setState(newState) {
    this.islandElem.classList.remove('state-idle', 'state-hover', 'state-expanded', 'state-max-expand');
    this.islandElem.classList.add(`state-${newState}`);
    this.currentState = newState;

    if (window.capsuleAPI?.setIslandState) {
      window.capsuleAPI.setIslandState(newState);
    }
  }

  collapseToIdle() {
    this.setState('idle');
  }
}

window.IslandController = IslandController;
