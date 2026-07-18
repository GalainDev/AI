class RateLimiter:
    def __init__(self, capacity):
        self.capacity = capacity

    def allow(self, key):
        raise NotImplementedError

    def _refill(self):
        # TODO: implement token refill based on elapsed time
        pass
