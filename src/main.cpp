#include "main.h"

#include <iostream>
#include <thread>

int main() {
  std::thread t([] () {
      std::cout << "Hello, World! (" << VERSION_STR << ")" << std::endl;
    });

  t.join();

  return 0;
}
