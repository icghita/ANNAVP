function out = renormalize(value, min, max)
    targetRange = max - min;
    out = value * targetRange + min;
end