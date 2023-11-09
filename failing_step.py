import logging
import random
import sys
import time

logging.basicConfig(level=logging.INFO)

fail_delay = random.randint(10, 30)
logging.error(f"I will fail in {fail_delay} seconds")

time.sleep(fail_delay)

sys.exit(1)
