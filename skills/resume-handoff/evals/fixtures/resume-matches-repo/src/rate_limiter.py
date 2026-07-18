class RateLimiter:
    def __init__(self, capacity):
        self.capacity = capacity

    def allow(self, key):
        raise NotImplementedError
