//
//	This is the app's main JS file.
//
//	It must export a single `default function` that gets imported and
//	executed by the two wrapper files in the parent `js` folder.
//

export default function() {
	document.body.addEventListener('click', (event) => {
		const target = event.target
		const quadPanel = target.closest('.quad-panel')
		const gamePanel = target.closest('.game-panel')

		if (quadPanel != null) {
			quadPanel.classList.toggle('hide')
		} else if (gamePanel != null) {
			gamePanel.classList.toggle('hide')
		}
	})
}
