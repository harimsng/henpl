#ifndef ETA_HPP
#define ETA_HPP

#include <vector>

#include "Utils.hpp"

class	Eta
{
public:
	Eta(const std::string& fileName)
  {
    m_range = parseRange(fileName);
    m_size = m_range.size() - 1;

    m_middleValues.assign(m_size, 0);
    for (size_t i = 0; i < m_size; ++i) {
      m_middleValues[i] = (m_range[i] + m_range[i + 1]) / 2;
    }
  };
	~Eta() = default;
	Eta(const Eta& eta) = delete;
	Eta	&operator=(const Eta& eta) = delete;

  /*
  std::pair<double, double> operator[](int index) const
  {
    return std::make_pair(getLowerBound(index), getUpperBound(index));
  };
  */

  double getLowerBound(int index) const
  {
    return m_range.at(index);
  };
  double getUpperBound(int index) const
  {
    return m_range.at(index + 1);
  };
  double getMiddleValue(int index) const
  {
    return m_middleValues[index];
  };

  size_t size() const
  {
    return m_size;
  };

private:
  std::vector<double> m_range;
  std::vector<double> m_middleValues;
  size_t m_size;
};

#endif // ETA_HPP