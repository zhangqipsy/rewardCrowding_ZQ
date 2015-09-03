function kb = keyDefinition()
  KbName('UnifyKeyNames')
  kb = struct();
  kb.escapeKey = KbName('escape');
  kb.leftArrow = KbName('LeftArrow'); % modify for Windows?
  kb.rightArrow = KbName('RightArrow');
  kb.upArrow = KbName('UpArrow');
  kb.downArrow = KbName('DownArrow');
  kb.SpaceKey = KbName('space');
  kb.LowBoundKey =  KbName('LeftControl');
  kb.HighBoundKey = KbName('LeftShift');
end
