local CodeElementSequenceUpdater = ecs.system({
    pool = {"codeElement", "visible"},
})

function CodeElementSequenceUpdater:init()
    self.codeElements = {}

    self.pool.onAdded = function(_, e)
        local sequence = self:getWorld().singletons.codeElementsSequence

        self.codeElements[e] = e.codeElement

        local prev = self:findFirstVisiblePrev(e.codeElement.prev.prev)

        if (prev) then
            sequence[prev] = e
        else
            sequence.root = e
        end

        local next = self:findFirstVisibleNext(e.codeElement.next.next)
        sequence[e] = next
    end

    self.pool.onRemoved = function(_, e)
        local sequence = self:getWorld().singletons.codeElementsSequence

        local codeElement = self.codeElements[e]

        local prev = self:findFirstVisiblePrev(codeElement.prev.prev)
        local next = self:findFirstVisibleNext(codeElement.next.next)

        if (not prev) then
            sequence.root = next
        else
            sequence[prev] = next
        end
        sequence[e] = nil
    end
end

function CodeElementSequenceUpdater:findFirstVisiblePrev(e)
    while (e and not e:has("visible")) do
        e = e.codeElement.prev.prev
    end

    return e
end

function CodeElementSequenceUpdater:findFirstVisibleNext(e)
    while (e and not e:has("visible")) do
        e = e.codeElement.next.next
    end

    return e
end



return CodeElementSequenceUpdater