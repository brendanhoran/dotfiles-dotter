#!/usr/bin/env python3
import i3ipc.aio as swayipc
import asyncio


class SwaySplitDirection:
    def __init__(self):
        # Output that ends up in Waybar via format{}.
        # V for Vertical, H for Horizontal
        self.splitv_text = 'V'
        self.splith_text = 'H'
        self.last = ''

    async def on_event(self, sway, event):
        """ Action to take once we have a event that matched

        Then query the layout for current split direction
        Once we have the direction, print to stdout and flush buffers immediately.
        """
        # Get the layout of the parent container for the currently in focus window
        # Since splitv and splith options are set on the parent container not a window
        try:
            tree = await sway.get_tree()
            layout = tree.find_focused().parent.layout
        except:  # noqa: E722
            # Always should have a focused window, if not swallow the error and move on
            pass

        # Match split direction or keep the existing split direction
        # Do not buffer output (See: https://github.com/Alexays/Waybar/discussions/2358)
        # Split vertical
        if layout == 'splitv' and layout != self.last:
            print(self.splitv_text, flush=True)
        # Split horizontal
        elif layout == 'splith' and layout != self.last:
            print(self.splith_text, flush=True)
        # Previous split direction
        elif layout != self.last:
            print(' ', flush=True)

        # Update the last layout
        self.last = layout

    async def run(self):
        """ Run the main async event loop

        Listens for events on window::focus and binding events
        """
        try:
            # Connect to the i3/sway socket via default path
            sway = await swayipc.Connection(auto_reconnect=True).connect()
        except Exception as e:
            print(f"Connection to Sway IPC failed: {e}")

        # Subscribe to window focus and binding events
        # Split direction is changed via a keyboard binding for a given window
        sway.on("window::focus", self.on_event)
        sway.on("binding", self.on_event)

        # Start the main loop and wait for events to come in
        await sway.main()


if __name__ == "__main__":
    ''' Show the current window split direction

    Uses IPC/socket to listen for window and key bind events
    Emits either V(Vertical) or H(Horizontal) to stdout to
    indicate the current window split direction.

    Inspired by:
    https://github.com/altdesktop/i3ipc-python/blob/master/examples/tiling-indicator.py
    '''

    # Create an instance of SwaySplitDirection and run via async
    tracker = SwaySplitDirection()
    asyncio.run(tracker.run())
