local smasIdleAnimations = {}

smasIdleAnimations.enabled = false --This is disabled UNLESS a character has an idle animation on file
smasIdleAnimations.idleTimer = 0 --The timer set. Increases when just standing on a level. If at a certain time, an idle animation will play.
smasIdleAnimations.isIdling = false --If true, the character is idling

return smasIdleAnimations